defmodule Mix.Tasks.Compile.Exref do
  use Mix.Task

  @shortdoc "Check all function calls using xref"

  @default_checks ~w/undefined_function_calls locals_not_used deprecated_function_calls/a

  def run(_args) do
    app_name = Mix.Project.config[:app] |> Atom.to_string
    ebin_dir = Path.join([Mix.Project.build_path, "lib", app_name, "ebin"]) |> String.to_char_list

    results = for c <- @default_checks do
      :xref_runner.check(c, %{dirs: [ebin_dir]})
    end

    results
    |> List.flatten
    |> print_and_raise_on_problems
  end

  defp print_and_raise_on_problems([]), do: nil
  defp print_and_raise_on_problems(problems) do
    problems
    |> Enum.map(&gen_comment/1)
    |> Enum.each(&IO.puts/1)

    Mix.raise "Error in xref check! Please fix any errors and try again."
  end

  defp gen_comment(xref_warn) do
    %{filename: filename, line: line, source: source, check: check} = xref_warn
    target = xref_warn[:target]

    pos = case {filename, line} do
            {"", _} -> ""
            {_, 0}  -> "#{filename} "
            {_, _}  -> "#{filename}:#{line} "
          end

    pos <> gen_comment_txt(check, source, target)
  end

  def gen_comment_txt(check, {sm, sf, sa}, tmfa) do
    sm = sm |> to_string |> String.replace("Elixir.", "")
    gen_comment_txt(check, "#{sm}.#{sf}/#{sa}", tmfa)
  end
  def gen_comment_txt(check, smfa, {tm, tf, ta}) do
    tm = tm |> to_string |> String.replace("Elixir.", "")
    gen_comment_txt(check, smfa, "#{tm}.#{tf}/#{ta}")
  end
  def gen_comment_txt(:undefined_function_calls, smfa, tmfa),  do: "#{smfa} calls undefined function #{tmfa}"
  def gen_comment_txt(:undefined_functions, smfa, _tmfa),      do: "#{smfa} is not defined as a function"
  def gen_comment_txt(:locals_not_used, smfa, _tmfa),          do: "#{smfa} is an unused local function"
  def gen_comment_txt(:exports_not_used, smfa, _tmfa),         do: "#{smfa} is an unused export"
  def gen_comment_txt(:deprecated_function_calls, smfa, tmfa), do: "#{smfa} calls deprecated function #{tmfa}"
  def gen_comment_txt(:deprecated_functions, smfa, _tmfa),     do: "#{smfa} is deprecated"
end
