require "active_support/dependencies"
require "logger"

ActiveSupport::Dependencies.autoload_paths << "lib"

module Toad

  def self.env
    @env ||= ENV["TOAD_ENV"] || ENV["RACK_ENV"] || "development"
  end

  def self.log msg, opts={}
    return unless Toad::Logger
    level = opts[:level] || :info
    Toad::Logger.send(level, msg)
  end

  unless ENV["TOAD_NOLOG"] or Toad.constants.any? { |c| c.to_s == "Logger" }
    Toad::Logger = Object::Logger.new(ENV["TOAD_LOG"] || $stdout)
    Toad::Logger.level = Object::Logger.const_get(ENV["LOG_LEVEL"] || ENV["TOAD_LOG_LEVEL"] || "DEBUG")
  end

  Models.connect!
end
