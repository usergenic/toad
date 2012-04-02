require "active_support/dependencies"
require "logger"

ActiveSupport::Dependencies.autoload_paths << "lib"

module Toad

  def self.env
    @env ||= ENV["TOAD_ENV"] || ENV["RACK_ENV"] || "development"
  end

  unless Toad.constants.any? { |c| c.to_s == "Logger" }
    Toad::Logger = Object::Logger.new(ENV["TOAD_LOG"] || $stdout) unless ENV["TOAD_NOLOG"]

    original_formatter = Object::Logger::Formatter.new
    Logger.formatter = proc do |severity, datetime, progname, msg|
      original_formatter.call(severity, datetime, progname, caller[4].to_s + " => " + msg.inspect)
    end
  end

  Models.connect!
end
