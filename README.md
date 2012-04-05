Toad
====

A lightweight project and dependency management app.

Installation
------------

The application setup is fairly standard Ruby app setup using Bundler.

    $ git clone https://github.com/brendan/toad.git
    $ cd toad
    $ bundle install
    $ bundle exec rackup

Toad uses MongoDB as its storage layer, so you'll need an instance of that
running too.  Installing Mongo is simple on the Mac with Homebrew:

    $ brew install mongodb
    $ mongod

The default configuration for MongoDB access will attempt to connect to a
database called "toad_$TOAD_ENV" where $TOAD_ENV defaults to whatever $RACK_ENV
is or simply "development".  It defaults to connect to localhost without a
username or password on the standard Mongodb port.  All these settings can be
overwritten by use of environment variables:

    TOAD_MONGODB_HOST
    TOAD_MONGODB_PORT
    TOAD_MONGODB_USERNAME
    TOAD_MONDODB_PASSWORD
    TOAD_MONGODB_DATABASE

By default the application logs everything to standard out.  If you want to turn
off logging, use the `TOAD_NOLOG` environment variable and set it to anything.
To write to a specific file use the `TOAD_LOG_FILE` environment variable and set
it to the path of a file that can be written to.

Setup First User Account
------------------------

A fresh installation will have no user accounts set up so you will need to
create the first user before doing anything else.  Visit your app at
http://localhost:9292/ and fill out the "Create First User" form.

Toad uses simple HTTP Basic Authentication.  No authentication is really secure
over insecure HTTP, so if HTTP Basic bothers you, you're going to want to setup
Toad on a server that supports SSL, which is beyond the scope of this document.

Now what do I do?
-----------------

Well you can start by adding a few projects you have on your mind.  Just go to
the Projects page and click "New Project".  Give it a title, add some Tags
(which are whatever you want them to be-- I use them to describe status mostly;
more about Tags later,) write a description (using Markdown) and then list any
dependencies you might have for that project.

The Tags and Dependencies fields use ajax autocomplete to lookup preexisting
values but do not restrict you to preexisting values, so new values will be
lazily created.  When you have finished typing an item in one of these fields,
hit enter and you'll see the text convert into a discrete little box, like the
way Facebook does its username lists when you create messages etc.

So basically the purpose of the app is to have a place to dump all the random
projects and tasks you want to do and then find out how they relate to each
other in terms of their dependencies or prerequisites.  So if you create 4
projects for example, where each has the next listed as a dependency...

    Project A -> Project B -> Project C -> Project D

When you view Project A's page, you'll see a path that reads:

    Project D, Project C, Project B, Project A

This indicates that D must be completed before C and before B and before A.
This is what Toad calls the Project Dependency Chain.

And so Tags are just like Tags pretty much in any other system.  The only extra
magic you get in Toad is that you can define colors for Tags.  Go to the Tags
tab and click a tag to see its edit form.  You can rename tags with this form
too.

That's basically it.

REST Client
-----------

NOTE: Before you can use the REST Client, you'll need to already have a user
created.  There's no programmatic interface for that currently.

Toad is meant to be accessed programattically.  The library includes a ruby
client that you use like this:

    >> toad = Toad::Client.new("http://username:password@127.0.0.1:9292/")
    => #<Toad::Client:0x007fb41426aeb0 ...>
    >> toad.list
    => []
    >> toad.create "Project Y", dependencies: ["Project Z"]
    => {"title" => "Project Y", "dependencies" => ["Project Z"]}
    >> toad.path_to "Project Y"
    => ["Project Z", "Project Y"]
    >> toad.create "Project X", dependencies: ["Project Y"]
    => {"title" => "Project X", "dependencies" => ["Project Y"]}
    >> toad.path_to "Project X"
    => ["Project Z", "Project Y", "Project X"]
    >> toad.list
    => ["Project X", "Project Y", "Project Z"]
    >> toad.update "Project Y", tags: ["Blocked"]
    => {"title" => "Project Y", "dependencies" => ["Project Z"], "tags" => ["Blocked"]}
    >> toad.update "Project Y", "dependencies" => []
    => {"title" => "Project Y", "dependencies" => [], "tags" => ["Blocked"]}

Technical Notes
---------------

It is written in Ruby using the Sinatra framework.  It is backed by MongoDB
using the Mongoid gem.  All major interactions with the web application are
covered by Cucumber features using Capybara with a `Rack::Test` driver.  The
styling all comes from the `fbootstrapp` project which endeavors to render
things in a Facebook iframe friendly way using the same concepts and techniques
of Twitter's `bootstrapp` library.

I also designed the app with the idea of deploying it to Heroku in mind.  It
turns out that you can get a ruby app with 240mb mongo instance FREE on Heroku,
so that's what I did.

If there was more time, some stuff I would have done
----------------------------------------------------

* There are no validations or error messages of any kind.  That should probably be addressed.
* Double-click text in view-mode to initiate inline edit
* Describe javascript autocomplete behaviors in cukes/specs
* Describe javascript filter-by-tag behaviors in cukes/specs
* Paginate the projects list
  * Filter-by-tag behavior should respect that paginated sets may require ajax call upon
    filter.
* Convert from ugly mongo ids to simple numeric ids, so they can be displayed
  and used as part of the recognizable identity.
* Provide a dependents edit field for projects
* Do something other than raise an exception when a circular dependency is
  encountered while rendering the path.  Ideally we should highlight the place
  where the loop is detected in the display so it can be addressed.
* Use canviz or something to draw dependency graphs
* Figure out a good interaction to filter excluding instead of just including.
