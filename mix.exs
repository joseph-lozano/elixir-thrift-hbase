defmodule HBase.Mixfile do
  use Mix.Project

  def project do
    [app: :hbase,
     compilers: [:thrift | Mix.compilers],
     thrift_files: Mix.Utils.extract_files(["thrift"], [:thrift]),
     version: "0.0.5",
     elixir: "~> 1.3",
     description: "A Wrapper for HBase Thrift Calls",
     package: package(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:logger, :poolboy],
      mod: {HBase, []}
   ]
  end

  def package do
    [
      name: :elixir_thrift_hbase,
      files: ["lib", "thrift", "src", "mix.exs"],
      maintainers: ["Joseph Lozano"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/joseph-lozano/elixir-thrift-hbase"},
      docs: [extras: ["README.md"]],
      deps: [{:thrift, github: "pinterest/elixir-thrift", submodules: true}]
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
      {:thrift, "~> 1.3"},
      {:poolboy, "~> 1.5"},
      {:earmark, ">= 0.0.0", only: :dev},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
end
