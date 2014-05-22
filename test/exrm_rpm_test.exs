defmodule ExrmRpmTest do
  use ExUnit.Case
  alias ReleaseManager.Config
  alias ReleaseManager.Utils
  alias ReleaseManager.Plugin.Rpm

  setup do
    config = %Config{name: "test", version: "0.0.1"}
    {:ok, config: Map.put(config, :rpm, true)}
  end

  test "creates the spec work directories", meta do
    Rpm.after_release(meta[:config])
  end
end
