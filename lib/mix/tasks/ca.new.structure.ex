defmodule Mix.Tasks.Ca.New.Structure do

  @moduledoc """
  Creates a new Clean architecture scaffold

      $ mix create_structure [application_name]
  """

  alias ElixirStructureManager.Core.ApplyTemplate
  alias ElixirStructureManager.Utils.DataTypeUtils
  require Logger

  use Mix.Task

  @structure_path "/priv/create_structure/parameters/create_structure.exs"
  @version Mix.Project.config()[:version]

  @switches [dev: :boolean, assets: :boolean, ecto: :boolean,
             app: :string, module: :string, web_module: :string,
             database: :string, binary_id: :boolean, html: :boolean,
             gettext: :boolean, umbrella: :boolean, verbose: :boolean,
             live: :boolean, dashboard: :boolean, install: :boolean,
             prefix: :string, mailer: :boolean]

  def run ([]) do
    Mix.Tasks.Help.run(["ca.new.structure"])
  end

  def run([version]) when version in ~w(-v --version) do
    Mix.shell().info("Scaffold version v#{@version}")
  end

  @shortdoc "Creates a new clean architecture application."
  def run([application_name]) do
    structure_path = Application.app_dir(:elixir_structure_manager) <> @structure_path
    with {:ok, atom_name, module_name} <- ApplyTemplate.manage_application_name(application_name),
         template <- ApplyTemplate.load_template_file(structure_path),
         {:ok, variable_list} <- ApplyTemplate.create_variables_list(atom_name, module_name) do
      ApplyTemplate.create_folder(template, atom_name, variable_list)
    else
      error -> Logger.error("Ocurrio un error creando la estructura: #{inspect(error)}")
    end
  end

  def run(argv) do
    IO.puts "Sending arguments"
    IO.inspect(argv)

    opts = DataTypeUtils.parse_opts(argv, @switches)
    IO.inspect(opts)

    case opts do
      {_opts, []} ->
        Mix.Tasks.Help.run(["ca.new.structure"])

      {opts, [base_path | _]} ->
        IO.inspect(opts)
        IO.inspect(base_path)
    end
  end

end
