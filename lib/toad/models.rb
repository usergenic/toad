require "mongoid"

module Toad::Models

  Mongoids = Project, User

  def self.connect!
    Mongoid.configure do |config|
      environment = Toad.env
      database_name = ENV["TOAD_MONGODB_DATABASE"] || "toad_#{environment}"
      connection_options = {}

      if ENV["TOAD_MONGODB_USERNAME"]
        connection_options[:auths] = {
          "username" => ENV["TOAD_MONGODB_USERNAME"],
          "password" => ENV["TOAD_MONGODB_PASSWORD"],
          "db_name"  => ENV["TOAD_MONGODB_DATABASE"]
        }
      end

      connection_options[:logger] = config.logger = Toad::Logger

      connection = Mongo::Connection.new \
        ENV["TOAD_MONGO_HOST"] || "localhost",
        ENV["TOAD_MONGO_PORT"] || "27017",
        connection_options

      config.master = connection[database_name]
    end
  end

  # Careful with this one
  def self.destroy_all!
    Mongoids.each &:destroy_all
  end
end
