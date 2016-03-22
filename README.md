# `Mix.Task.Compile.Exref`

Mix integration of [xref](http://erlang.org/doc/apps/tools/xref_chapter.html).
Constantly running xref makes you look smarter (by suppressing stupid mistakes)!
- [Hex package information](https://hex.pm/packages/exref)

## Usage

- Add `:exref` to your list of dependencies in `mix.exs`.
- `$ mix deps.get`
- `$ mix compile.exref` checks all function calls in your mix project.
- If you want to run `exref` every time you compile your mix project, overwrite `compilers` of  `project/0` in your `mix.exs`:

    ```ex
    def project do
      [
        ...
        compilers: Mix.compilers ++ [:exref],
        ...
      ]
    end
    ```
