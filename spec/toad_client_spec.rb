require "spec_helper"
require "toad/client"

describe Toad::Client do

  before do
    user = Toad::Models::User.create username: "alice", password: "wonderland"
    @client = Toad::Client.new "http://alice:wonderland@toad"
  end

  describe Toad::Client, "#initialize" do
  end

  describe Toad::Client, "#list" do

    it "returns an array of all project titles in the system" do
      Toad::Models::Project.create title: "Project A"
      Toad::Models::Project.create title: "Project B"

      list = @client.list
      list.should == ["Project A", "Project B"]
    end
  end

  describe Toad::Client, "#lookup" do

    it "looks up a Project by its title" do
      basic = Toad::Models::Project.create title: "Basic Codes"
      cool  = Toad::Models::Project.create title: "Cool Codes", description: "Ice cold...", dependencies: [ basic ]

      @client.lookup("Cool Codes").should == {
        "id" => cool.id.to_s,
        "title" => "Cool Codes",
        "description" => "Ice cold...",
        "dependencies" => ["Basic Codes"],
        "tags" => []
      }
    end
  end

  describe Toad::Client, "#create" do

    it "properly creates a Project" do
      response = @client.create "Magic Project",
        description: "It is magical",
        dependencies: ["Magicsauce", "White Rabbit Dispenser"],
        tags: ["magical"]

      response.should == {
        "id" => Toad::Models::Project.where(title: "Magic Project").first.id.to_s,
        "title" => "Magic Project",
        "description" => "It is magical",
        "dependencies" => ["Magicsauce", "White Rabbit Dispenser"],
        "tags" => ["magical"]
      }
    end
  end

  describe Toad::Client, "#update" do

    it "updates the params it is given... and only those params" do
      a = Toad::Models::Project.create title: "a"
      t = Toad::Models::Tag.create text: "t"
      x = Toad::Models::Project.create \
        title: "x",
        description: "d",
        dependencies: [a],
        tags: [t]

      @client.update("x", title: "y").should == {
        "id" => x.id.to_s,
        "title" => "y",
        "description" => "d",
        "dependencies" => ["a"],
        "tags" => ["t"]
      }
    end
  end
end
