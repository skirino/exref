defmodule Mix.Tasks.Compile.Exref do
  use Mix.Task

  @shortdoc "Checks all function calls using xref"

  def run(_args) do
    results = :xref.d(ebin_dir)
    if !Enum.all?(results, &match?({_, []}, &1)) do
      Enum.flat_map(results, &format_errors/1) |> Enum.join("\n") |> IO.puts
      Mix.raise "Error in xref check! Please fix any errors and try again."
    end
  end

  defp ebin_dir do
    app_name = Mix.Project.config[:app] |> Atom.to_string
    Path.join([Mix.Project.build_path, "lib", app_name, "ebin"]) |> String.to_char_list
  end

  defp format_errors({analysis, errors}) do
    Enum.map(errors, &format(analysis, &1))
  end

  defp format(:deprecated, {caller, called}) do
    "xref warning: #{mfa_with_location(caller)} calls deprecated function #{mfa(called)}"
  end
  defp format(:undefined, {caller, called}) do
    "xref warning: #{mfa_with_location(caller)} calls undefined function #{mfa(called)}"
  end
  defp format(:unused, mfa) do
    "xref warning: #{mfa_with_location(mfa)} is unused local function"
  end

  defp mfa({m, f, a}) do
    module_str = Atom.to_string(m) |> String.replace_prefix("Elixir.", "")
    "#{module_str}.#{f}/#{a}"
  end

  defp mfa_with_location({m, f, a}) do
    "#{extract_source_and_line(m, f, a)}: #{mfa({m, f, a})}"
  end

  defp extract_source_and_line(m, f, a) do
    {_, bin, _} = :code.get_object_code(m)
    {:ok, {^m, [abstract_code: {:raw_abstract_v1, defs}]}} = :beam_lib.chunks(bin, [:abstract_code])
    {_, _, _, {source, _}} = Enum.find(defs, &match?({:attribute, _, :file, _}, &1))
    case Enum.find(defs, &match?({:function, _, ^f, ^a, _}, &1)) do
      {_, line, _, _, _} -> "#{source}:#{line}"
      nil                -> List.to_string(source)
    end
  end
end
