require "active_support/dependencies"
require "logger"

ActiveSupport::Dependencies.autoload_paths << "lib"

module Toad

  def self.env
    @env ||= ENV["TOAD_ENV"] || ENV["RACK_ENV"] || "development"
  end

  Logger = Object::Logger.new(ENV["TOAD_LOG"] || $stdout) unless ENV["TOAD_NOLOG"]

  Models.connect!
end
