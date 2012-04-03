module Toad::Models

  class Project
    CircularDependencyError = Class.new(RuntimeError)

    include Mongoid::Document

    field :title,       type: String
    field :description, type: String

    has_and_belongs_to_many :dependencies, class_name: "Toad::Models::Project"
    has_and_belongs_to_many :tags, class_name: "Toad::Models::Tag"

    def path(branch=[])
      raise CircularDependencyError if branch.include? self

      branches = dependencies.map do |dependency|
        begin
          branch.push self
          dependency.path(branch)
        ensure
          branch.pop
        end
      end

      branches.flatten!
      branches.push(self)
      branches.uniq
    end
  end
end
