defmodule ReleaseManager.Plugin.Rpm do
  use ReleaseManager.Plugin
  alias ReleaseManager.Config

  @_SPEC        "spec"
  @_INIT_FILE   "init_script"
  @_RPM_DIR     "rpm"
  @_DEFAULT_BUILD_ARCH  "x86_64"
  @_DEFAULT_SUMMARY    "Add a summary entry in your project config"
  @_DEFAULT_DESCRIPTION "Add a description your config file"
  @_RPM_TEMPLATE_DIR   Path.join([@_RPM_DIR, "templates"])
  @_RPM_SPEC_DIRS  [
    ["SPECS"], 
    ["SOURCES"],
    ["RPMS", "x86_64"],
    ["SRPMS"],
    ["BUILD"]
  ]

  @_RELEASES    "{{{RELEASES}}}"
  @_NAME        "{{{PROJECT_NAME}}}"
  @_VERSION     "{{{PROJECT_VERSION}}}"
  @_ERTS_VSN    "{{{ERTS_VERSION}}}"
  @_ERL_OPTS    "{{{ERL_OPTS}}}"
  @_ELIXIR_PATH "{{{ELIXIR_PATH}}}"
  @_TOPDIR      "{{{PROJECT_TOPDIR}}}"
  @_BUILD_ARCH  "{{{BUILD_ARCHITECTURE}}}"
  @_SUMMARY     "{{{SUMMARY}}}"
  @_DESCRIPTION "{{{DESCRIPTION}}}"
 
  def before_release(_), do: nil
  
  def after_release(%{rpm: true} = config) do
    config 
    |> do_config
    |> do_spec
    |> do_init_script
    |> create_rpm
  end

  def after_release(_), do: nil

  defp do_config(%Config{name: name, version: version} = config) do
    app_name = "#{name}-#{version}.tar.gz"
    build_dir = config |> Map.get(:build_dir, Path.join([File.cwd!, "_build", "rpm"]))
    config
      |> Map.merge(%{ 
        priv:          config |> Map.get(:priv_path, Path.join([__DIR__, "..", "..", "priv"]) |> Path.expand),
        build_dir:     build_dir,
        app_name:      app_name,
        app_tar_path:  Path.join([File.cwd!, "rel", name, app_name]),
        target_rpm_path: Path.join([File.cwd!, "rel", name, "releases", version, rpm_file_name(name, version)]),
        sources_path:  Path.join([build_dir, "SOURCES", app_name]),
        init_dir:      Path.join(["etc", "init.d"]),
        rpmbuild:      "/usr/bin/rpmbuild",
        rpmbuild_opts: "-bb", 
        build_arch:    config |> Map.get(:build_arch, @_DEFAULT_BUILD_ARCH),
      })
  end

  defp do_spec(%Config{name: name, version: version} = config) do
    info "Generating rpm..." 

    dest = Path.join([config.build_dir, "SPECS", "#{name}.spec"])
    spec = get_rpm_template_path(config.priv, @_SPEC)
    app         = binary_to_atom name
    summary     = Application.get_env(app, :summary, @_DEFAULT_SUMMARY)
    description = Application.get_env(app, :description, @_DEFAULT_DESCRIPTION)

    build_tmp_build(config.build_dir)

    contents = File.read!(spec)
    |> String.replace(@_NAME, name)
    |> String.replace(@_VERSION, version)
    |> String.replace(@_TOPDIR, config.build_dir)
    |> String.replace(@_BUILD_ARCH, config.build_arch)
    |> String.replace(@_SUMMARY, summary)
    |> String.replace(@_DESCRIPTION, description)

    File.write!(dest, contents)
    config
  end

  defp do_init_script(%Config{name: name, version: version} = config) do
    info "Generating init.d script..." 

    dest = Path.join([config.build_dir, "SOURCES", "#{name}"])

    contents = get_rpm_template_path(config.priv, @_INIT_FILE) 
    |> File.read!
    |> String.replace(@_NAME, name)

    File.write!(dest, contents)
    config
  end

  defp create_rpm(%Config{name: name, version: version} = config) do
    info "Building rpm..." 

    if File.exists? config.app_tar_path do
      File.cp!(config.app_tar_path, config.sources_path)
      spec_path = Path.join([config.build_dir, "SPECS", "#{name}.spec"])
      build_rpm_path = Path.join([config.build_dir, "RPMS", config.build_arch, 
        rpm_file_name(name, version)])
      unless File.exists?(config.rpmbuild) do
        warn """
        Cannot find rpmbuild tool #{config.rpmbuild}. Skipping rpm build!
        The generated build files can be found in #{config.build_dir} 
        """
      else
        System.cmd "#{config.rpmbuild} #{config.rpmbuild_opts} #{spec_path}"
        File.copy! build_rpm_path, config.target_rpm_path
        info "Rpm file #{config.target_rpm_path} created!"
      end 
    else
      error "Could not find the release file #{config.app_tar_path}"
    end
    config
  end

  defp build_tmp_build(build_dir) do
    @_RPM_SPEC_DIRS 
    |> Enum.each(&(File.mkdir_p! Path.join([build_dir | &1])))
  end

  defp get_rpm_template_path(priv, filename) do
    custom_location = Path.join([File.cwd!, @_RPM_TEMPLATE_DIR, filename])
    if File.exists?(custom_location) do 
      custom_location
    else
      Path.join([priv, "rel", "files", filename])
    end
  end

  defp rpm_file_name(name, version), do: "#{name}-#{version}-0.rpm"

end
