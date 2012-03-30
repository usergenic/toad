module Toad::Models

  class Project

    include Mongoid::Document

    field :title,       type: String
    field :description, type: String

    has_and_belongs_to_many :dependencies, class_name: "Toad::Models::Project"
  end
end
