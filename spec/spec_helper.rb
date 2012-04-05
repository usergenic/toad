ENV["TOAD_ENV"] = "test"
ENV["TOAD_LOG"] ||= "log/test.log" unless ENV["TOAD_NOLOG"]

$LOAD_PATH.unshift "lib"

require "rspec/autorun"
require "rack/test"
require "artifice"
require "toad"

RSpec.configure do |config|

  config.include Rack::Test::Methods

  config.before do

    Toad::Models.destroy_all!

    Artifice.activate_with Toad::Web

    def app()
      Toad::Web
    end
  end

  config.after do
    Artifice.deactivate
  end
end
