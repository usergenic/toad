require "rest-client"

module Toad

  class Client

    attr_reader :baseurl

    def initialize(baseurl)
      @baseurl = baseurl
    end

    def list
      url = join(baseurl, "projects")
      res = RestClient.get(url, accept: "application/json")
      JSON.parse(res.body)
    end

    private

    def join *segs
      segs.map {|seg| seg.to_s.gsub(%r{^/|/$},'')}.join("/")
    end
  end
end
