# Let toad be used as a gem, so manage dependencies there.
source :rubygems

=begin

I'm having trouble figuring out how to get heroku to be cool with a Gemfile that
uses the "gemspec" directive.  Heroku reports the following fail:

$ git push heroku master
-----> Heroku receiving push
-----> Ruby/Rack app detected
-----> Gemfile detected, running Bundler version 1.0.7
       Unresolved dependencies detected; Installing...
       Using --without development:test
       fatal: Not a git repository (or any of the parent directories): .git
       You have modified your Gemfile in development but did not check
       the resulting snapshot (Gemfile.lock) into version control

       You have added to the Gemfile:
       * source: source at /disk1/tmp/build_6yo3bsi6ie6j
       * activesupport

       You have deleted from the Gemfile:
       * source: source at .

       You have changed in the Gemfile:
       * toad from `source at /disk1/tmp/build_6yo3bsi6ie6j` to `no specified source`
       FAILED: http://devcenter.heroku.com/articles/bundler
 !     Heroku push rejected, failed to install gems via Bundler

To git@heroku.com:glowing-mountain-1353.git
 ! [remote rejected] master -> master (pre-receive hook declined)
error: failed to push some refs to 'git@heroku.com:glowing-mountain-1353.git'

=end

gem "mongoid"
gem "bson_ext"
gem "sinatra"
gem "haml"
gem "maruku"
gem "rack-abstract-format"
gem "rack-accept-media-types"
gem "rest-client"

group :development do
  gem "artifice"
  gem "capybara"
  gem "cucumber"
  gem "rack-test"
  gem "rake"
  gem "rspec"
end


