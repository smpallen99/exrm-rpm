defmodule ReleaseManager.Plugin.Rpm do
  use ReleaseManager.Plugin
  alias ReleaseManager.Config
  alias ReleaseManager.Utils

  def before_release(%Config{name: app, version: version}) do
    warn "#{__MODULE__}: generating rpm for #{app}-#{version}"
  end
  
  def after_release(%Config{name: app, version: version}) do
    info "#{__MODULE__}: rpm for #{app}-#{version} created!!"
  end
end
