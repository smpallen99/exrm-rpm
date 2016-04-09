defmodule ExrmRpmTest do
  use ExUnit.Case
  alias ReleaseManager.Config
  alias ReleaseManager.Plugin.Rpm

  setup do
    File.rm_rf Path.join([File.cwd!, "_build", "rpm"])
    config = %Config{name: "test", version: "0.0.1"}
    {:ok, config: Map.merge(config, %{rpm: true, build_arch: "x86_64"})}
  end

  def create_rpm_build(config) do
    build_arch = Rpm.get_config_item config, :build_arch, "x86_64"
    rpm_file = Rpm.rpm_file_name(config.name, config.version, build_arch)
    IO.puts rpm_file
  end

  test "creates the spec work directories", meta do
    Rpm.after_release(meta[:config])
  end

  test "creates RPMS arch path", meta do
    %{meta[:config] | build_arch: "i386"}
    |> Rpm.after_release
    assert File.exists?(Path.join([File.cwd!, "_build", "rpm", "RPMS", "i386"]))
  end 
end
