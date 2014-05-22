defmodule Mix.Tasks.Release.Copy_rpm_templates do
  @moduledoc """
  Create a copy of the Rpm Templates

  Creates copies of the templates for customization.

  ## Examples

    # Create a copy of the templates
    mix release.copy_rpm_templates
    # Over write existing custom templates
    mix release.copy_rpm_templates --overwrite

  """
  @shortdoc "Create a copy of the Rpm Templates."

  use     Mix.Task
  import  ReleaseManager.Utils

  @_RPM_DIR  "rpm"
  @_RPM_TEMPLATE_DIR   Path.join([@_RPM_DIR, "templates"])
  @_TEMPLATE_FILES     ["spec", "init_script"]

  def run(args) do
    debug "creating copies...."
    config = [ priv_path:  Path.join([__DIR__, "..", "..", "..", "priv"]) |> Path.expand,
               name:       Mix.project |> Keyword.get(:app) |> atom_to_binary,
             ]
    config
    |> Keyword.merge(args |> parse_args)
    |> do_copy_templates
    info "The templates can be found in #{@_RPM_TEMPLATE_DIR}"
  end

  # Clean release build
  def do_copy_templates(config) do
    cwd        = File.cwd!
    priv       = config |> Keyword.get(:priv_path)
    overwrite? = config |> Keyword.get(:overwrite)
    name       = Mix.project |> Keyword.get(:app) |> atom_to_binary

    templ_dir  = Path.join([cwd, @_RPM_TEMPLATE_DIR])

    File.mkdir_p!(templ_dir)

    @_TEMPLATE_FILES 
    |> Enum.each(fn(filename) -> 
      path   = Path.join([priv, "rel", "files", filename])
      target = Path.join([cwd, @_RPM_TEMPLATE_DIR, filename])
      if File.exists?(target) and !overwrite? do 
        info "Template file #{path} exists. Please use --overwrite overwrite the existing file."
      else
        File.cp!(path, target)
      end
    end)
  end
  defp parse_args(argv) do
    {args, _, _} = OptionParser.parse(argv)
    args |> Enum.map(&parse_arg/1)
  end
  defp parse_arg({_key, _value} = arg),    do: arg
end
