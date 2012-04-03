require "sinatra/base"

module Toad

  class Web < Sinatra::Base

    enable :logging
    enable :dump_errors
    enable :show_exceptions

    set :haml, ugly: true
    set :public_folder, __FILE__.sub(/\.rb$/, "/public")
    set :views, __FILE__.sub(/\.rb$/, "/views")

    use Rack::MethodOverride

    if Toad::Logger
      # define #write for Rack::CommonLogger compatability
      Toad::Logger.class_eval { alias write info }
      use Rack::CommonLogger, Toad::Logger
      enable :logging
    end

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

    get users_path do
      @users = User.all(sort: [[:title, :asc]])
      haml :"users/index"
    end

    get new_user_path do
      @user = User.new
      haml :"users/new"
    end

    post users_path do
      @user = User.create \
        username: params[:username],
        password: params[:password]
     redirect user_path(@user.id)
    end

    get user_path(":user_id") do
      @user = User.find(params[:user_id])
      haml :"users/show"
    end

    get edit_user_path(":user_id") do
      @user = User.find(params[:user_id])
      haml :"users/edit"
    end

    put user_path(":user_id") do
      @user = User.find(params[:user_id])
      @user.update_attributes \
        username: params[:username],
        password: params[:password]
      redirect user_path(@user.id)
    end

    get remove_user_path(":user_id") do
      @user = User.find(params[:user_id])
      haml :"users/remove"
    end

    delete user_path(":user_id") do
      @user = User.find(params[:user_id])
      @user.destroy
      redirect users_path
    end

    get projects_path do
      @projects = Project.all(sort: [[:title, :asc]])
      haml :"projects/index"
    end

    get projects_autocomplete_path do
      @projects = Project.only(:id, :title).asc(:title).limit(30)
      q = params[:q].to_s
      unless q.empty?
        js_matcher = "this.title.toLowerCase().indexOf(#{q.downcase.to_json})+1"
        @projects = @projects.where(js_matcher)
        @projects.sort_by! { |p| [p.title =~ Regexp.new(Regexp.escape(q)), p.title] }
      end
      @projects.map(&:title).to_json
    end

    get new_project_path do
      @project = Project.new
      haml :"projects/new"
    end

    post projects_path do
      dependencies = parse_dependencies_param(params[:dependencies])
      tags = parse_tags_param(params[:tags])
      @project = Project.create \
        title:        params[:title],
        description:  params[:description],
        dependencies: dependencies,
        tags:         tags
      redirect project_path(@project.id)
    end

    get project_path(":project_id") do
      @project = Project.find(params[:project_id])
      haml :"projects/show"
    end

    get edit_project_path(":project_id") do
      @project = Project.find(params[:project_id])
      haml :"projects/edit"
    end

    put project_path(":project_id") do
      dependencies = parse_dependencies_param(params[:dependencies])
      tags = parse_tags_param(params[:tags])
      @project = Project.find(params[:project_id])
      @project.update_attributes \
        title:        params[:title],
        description:  params[:description],
        dependencies: dependencies,
        tags:         tags
      redirect project_path(@project.id)
    end

    get remove_project_path(":project_id") do
      @project = Project.find(params[:project_id])
      haml :"projects/remove"
    end

    delete project_path(":project_id") do
      @project = Project.find(params[:project_id])
      @project.destroy
      redirect projects_path
    end

    get tags_path do
      @tags = Tag.all(sort: [[:text, :asc]]).to_a
      haml :"tags/index"
    end

    get new_tag_path do
      @tag = Tag.new
      haml :"tags/new"
    end

    post tags_path do
      Tag.create \
        text:      params[:text],
        treatment: params[:treatment]
      redirect tags_path
    end

    get edit_tag_path(":tag_id") do
      @tag = Tag.find(params[:tag_id])
      haml :"tags/edit"
    end

    put tag_path(":tag_id") do
      @tag = Tag.find(params[:tag_id])
      @tag.update_attributes \
        text:      params[:text],
        treatment: params[:treatment]
      redirect tags_path
    end

    get tags_autocomplete_path do
      @tags = Tag.only(:id, :text).asc(:text).limit(30)
      q = params[:q].to_s
      unless q.empty?
        js_matcher = "this.text.toLowerCase().indexOf(#{q.downcase.to_json})+1"
        @tags = @tags.where(js_matcher)
        @tags.sort_by! { |t| [t.text =~ Regexp.new(Regexp.escape(q)), t.text] }
      end
      @tags.map(&:text).to_json
    end

    private

    def parse_dependencies_param(param)
      titles = JSON.parse(param.to_s)
      Toad::Models::Project.where(:title.in => titles).all.to_a
    end

    def parse_tags_param(param)
      texts = JSON.parse(param.to_s)
      tags = Toad::Models::Tag.where(:text.in => texts).all.to_a
      texts.each do |text|
        next if tags.any? { |tag| tag.text == text }
        tags << Toad::Models::Tag.create(text: text)
      end
      tags
    end
  end
end
