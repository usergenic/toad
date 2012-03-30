task :env do
  require "toad"
end

namespace :db do

  desc "clear database of everything"
  task :reset => :env do
    Toad::Models.destroy_all!
  end
end
