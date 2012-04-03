module Toad::Models

  class Tag

    include Mongoid::Document

    has_and_belongs_to_many :projects, class_name: "Toad::Models::Project"

    field :text, type: String
    field :treatment, type: String, default: "default"
  end
end
