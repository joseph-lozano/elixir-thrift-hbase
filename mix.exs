defmodule HBase.Mixfile do
  use Mix.Project

  def project do
    [app: :hbase,
     version: "0.0.1",
     elixir: "~> 1.2",
     description: "A Wrapper for HBase Thrift Calls",
     package: package,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  def package do
    [
      name: :elixir_thrift_hbase,
      files: ["lib", "src", "mix.exs"],
      maintainers: ["Joseph Lozano"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/joseph-lozano/elixir-thrift-hbase"},
      docs: [extras: ["README.md"]]
    ]
  end
  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:earmark, ">= 0.0.0", only: :dev},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
end
