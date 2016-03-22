defmodule Mix.Tasks.Compile.Exref do
  use Mix.Task

  @shortdoc "Check all function calls using xref"

  def run(_args) do
    app_name = Mix.Project.config[:app] |> Atom.to_string
    ebin_dir = Path.join([Mix.Project.build_path, "lib", app_name, "ebin"]) |> String.to_char_list
    results = :xref.d(ebin_dir)
    Enum.each(results, &print_and_halt_on_nonempty/1)
  end

  defp print_and_halt_on_nonempty({_, []}), do: nil
  defp print_and_halt_on_nonempty({label, funcalls}) do
    IO.puts("exref error: #{label}")
    Enum.each(funcalls, fn f -> IO.puts("  #{inspect f}") end)
    Mix.raise "Error in xref check! Please fix any errors and try again."
  end
end
