require "mongoid"

module Toad::Models

  Mongoids = Project, User

  def self.connect!
    return if @connected

    Toad.log [self, "connecting..."]

    Mongoid.configure do |config|
      environment = Toad.env
      database_name = ENV["TOAD_MONGODB_DATABASE"] || "toad_#{environment}"
      connection_options = {}

      if ENV["TOAD_MONGODB_USERNAME"]
        connection_options[:auths] = {
          "username" => ENV["TOAD_MONGODB_USERNAME"],
          "password" => ENV["TOAD_MONGODB_PASSWORD"],
          "db_name"  => database_name
        }
      end

      connection_options[:logger] = config.logger = Toad::Logger

      connection = Mongo::Connection.new \
        ENV["TOAD_MONGODB_HOST"] || "localhost",
        ENV["TOAD_MONGODB_PORT"] || "27017",
        connection_options

      config.master = connection[database_name]
    end

    Toad.log [self, "connected."]
    @connected = true
  end

  # Careful with this one
  def self.destroy_all!
    Mongoids.each &:destroy_all
  end
end
