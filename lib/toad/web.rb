require "sinatra/base"

module Toad

  class Web < Sinatra::Base

    set :public_folder, __FILE__.sub(/\.rb$/, "/public")
    set :views,         __FILE__.sub(/\.rb$/, "/views")

    extend Resources
    include Resources
    include Models
    include Authentication
    include HTML

    before do
      if User.any?
        require_authentication!
      else
        redirect first_user_path unless request.path == first_user_path
      end
    end

    get home_path do
      haml :"welcome"
    end

    get first_user_path do
      redirect home_path if current_user
      @user = User.new
      haml :"first_user"
    end

    post first_user_path do
      redirect home_path if current_user
      @user = User.create \
        username: params[:username],
        password: params[:password]
      redirect home_path
    end

    get projects_path do
      @projects = Project.all
      haml :"projects/index"
    end
  end
end
