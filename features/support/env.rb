ENV["TOAD_ENV"] = "test"
ENV["TOAD_LOG"] ||= "log/test.log" unless ENV["TOAD_NOLOG"]

require "capybara/cucumber"
require "toad"

$LOAD_PATH << File.dirname(__FILE__)

require "http_basic_auth_helper"

Capybara.app = Toad::Web

World HttpBasicAuthHelper
World Toad::Models
World Toad::Web::Resources

Before { Toad::Models.destroy_all! }

