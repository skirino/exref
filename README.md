# `Mix.Task.Compile.Exref`

*As of Elixir 1.3.0 `mix xref` is introduced; this additional hex package is useful only to Elixir < 1.3.0.*

Mix integration of [xref](http://erlang.org/doc/apps/tools/xref_chapter.html) to check correctness of function calls after compilation, inspired by [a post by @elbrujohalcon in inaka's blog](http://inaka.net/blog/2015/07/17/erlang-meta-test/).
Constantly running xref makes you look smarter (by suppressing stupid mistakes)!
- [Hex package information](https://hex.pm/packages/exref)

## Usage

- Add `:exref` to your list of dependencies in `mix.exs`.
- `$ mix deps.get`
- Overwrite `compilers` of  `project/0` in your `mix.exs` to run `exref` every time you compile your project:

    ```ex
    def project do
      [
        ...
        compilers: Mix.compilers ++ [:exref],
        ...
      ]
    end
    ```
