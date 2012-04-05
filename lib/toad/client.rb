require "rest-client"
require "uri"
require "toad/web/resources"

module Toad

  class Client

    # This is where we get the named routes.
    include Toad::Web::Resources

    attr_reader :http

    def initialize(baseurl)
      @baseurl = baseurl
    end

    def lookup(title)
      get lookup_project_path, title: title
    end

    def list
      get projects_path
    end

    def create(title, params)
      post projects_path, params.merge(title: title)
    end

    def update(title, params)
      params = Hash[params.map { |k, v| [k.to_s, v] }]
      base = lookup(title)
      base.each { |k, v| params[k] = v unless params.key? k }
      put project_path(base["id"]), params
    end

    private

    def get path, params={}
      opts = {params: params, accept: "application/json"}
      response = RestClient.get join(@baseurl, path), opts
      JSON.parse(response.body)
    end

    def post path, params={}
      opts = params.merge accept: "application/json"

      response, *r = RestClient.post(join(@baseurl, path), opts){ |*r| r }
      get URI.parse(response.net_http_res.header["location"]).path.to_s
    end

    def put path, params={}
      opts = params.merge accept: "application/json"

      response, *r = RestClient.put(join(@baseurl, path), opts){ |*r| r }
      get URI.parse(response.net_http_res.header["location"]).path.to_s
    end

    def join *segs
      segs.map {|seg| seg.to_s.gsub(%r{^/|/$},'')}.join("/")
    end
  end
end
