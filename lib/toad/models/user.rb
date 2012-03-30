module Toad::Models

  class User

    include Mongoid::Document

    field :username, type: String
    field :password, type: String

    def self.any?
      !!first
    end

    def self.find_by_username_and_password(username, password)
      where(username: username, password: password).first
    end
  end
end
