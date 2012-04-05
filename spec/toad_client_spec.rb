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

  describe Toad::Client, "#get" do
  end

  describe Toad::Client, "#create" do
  end

  describe Toad::Client, "#update" do
  end
end
