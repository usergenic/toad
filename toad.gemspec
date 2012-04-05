Gem::Specification.new do |s|
  s.name          = "toad"
  s.version       = "1.0.0"
  s.authors       = ["Brendan Baldwin"]
  s.email         = ["brendan@usergenic.com"]
  s.homepage      = "https://github.com/brendan/toad"
  s.summary       = %q{toad: "TO A Destination" a simple web application that links projects to each other and helps you find your way to your destination.}
  s.description   = %q{Are you one of these people that has a million ideas for projects that are sometimes interrelated and you need to manage all that somehow but feel like existing project management tools and such are too heavy or not useful for charting the way etc etc?  Let the Toad help!}
  s.files         = `git ls-files`.split("\n")
  s.executables   = s.files.grep(/^bin\//).map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "activesupport"
  s.add_dependency "mongoid"
  s.add_dependency "bson_ext"
  s.add_dependency "sinatra"
  s.add_dependency "haml"
  s.add_dependency "maruku"
  s.add_dependency "rack-abstract-format"
  s.add_dependency "rack-accept-media-types"
  s.add_dependency "rest-client"

  s.add_development_dependency "artifice"
  s.add_development_dependency "capybara"
  s.add_development_dependency "cucumber"
  s.add_development_dependency "rack-test"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
