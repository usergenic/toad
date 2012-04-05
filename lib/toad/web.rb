require "sinatra/base"
require "rack/abstract_format"
require "rack/accept_media_types"

module Toad

  class Web < Sinatra::Base

    enable :logging
    enable :dump_errors
    enable :show_exceptions

    set :haml, ugly: true
    set :views, __FILE__.sub(/\.rb$/, "/views")

    use Rack::Static, urls: ["/css", "/js"], root: __FILE__.sub(/\.rb$/, "/public")
    use Rack::MethodOverride
    use Rack::AbstractFormat

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
      respond_with "welcome"
    end

    get first_user_path do
      redirect home_path if current_user
      @user = User.new
      respond_with "first_user"
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
      respond_with "users/index"
    end

    get new_user_path do
      @user = User.new
      respond_with "users/new"
    end

    post users_path do
      @user = User.create \
        username: params[:username],
        password: params[:password]
     redirect user_path(@user.id)
    end

    get user_path(":user_id") do
      @user = User.find(params[:user_id])
      respond_with "users/show"
    end

    get edit_user_path(":user_id") do
      @user = User.find(params[:user_id])
      respond_with "users/edit"
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
      respond_with "users/remove"
    end

    delete user_path(":user_id") do
      @user = User.find(params[:user_id])
      @user.destroy
      redirect users_path
    end

    get projects_path do
      @projects = Project.all(sort: [[:title, :asc]])
      respond_with "projects/index"
    end

    get projects_autocomplete_path do
      @projects = Project.only(:id, :title).asc(:title).limit(30)
      q = params[:q].to_s
      unless q.empty?
        js_matcher = "this.title.toLowerCase().indexOf(#{q.downcase.to_json})+1"
        @projects = @projects.where(js_matcher)
        @projects.sort_by! { |p| [p.title =~ Regexp.new(Regexp.escape(q)), p.title] }
      end
      respond_with "projects/autocomplete"
    end

    get new_project_path do
      @project = Project.new
      respond_with "projects/new"
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
      respond_with "projects/show"
    end

    get edit_project_path(":project_id") do
      @project = Project.find(params[:project_id])
      respond_with "projects/edit"
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
      respond_with "projects/remove"
    end

    delete project_path(":project_id") do
      @project = Project.find(params[:project_id])
      @project.destroy
      redirect projects_path
    end

    get tags_path do
      @tags = Tag.all(sort: [[:text, :asc]]).to_a
      respond_with "tags/index"
    end

    get new_tag_path do
      @tag = Tag.new
      respond_with "tags/new"
    end

    post tags_path do
      Tag.create \
        text:      params[:text],
        treatment: params[:treatment]
      redirect tags_path
    end

    get edit_tag_path(":tag_id") do
      @tag = Tag.find(params[:tag_id])
      respond_with "tags/edit"
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
      respond_with "tags/autocomplete"
    end

    private

    # TODO: port the duplicative logic in parse_* methods to a
    # Toad::Models#find_or_create_all_by method.
    def parse_dependencies_param(param)
      titles = JSON.parse(param.to_s)
      projects = Toad::Models::Project.where(:title.in => titles).all.to_a
      titles.each do |title|
        next if projects.any? { |project| project.title == title }
        projects << Toad::Models::Project.create(title: title)
      end
      projects
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

    def respond_with(template, options={})
      accepted_types = *(options[:accept] || ["application/json", "text/html"])
      media_type = request.accept_media_types.find do |type|
        accepted_types.include?(type)
      end
      case media_type
      when "application/json"
        [200, {"Content-Type" => "application/json"}, erb(template.to_sym)]
      else haml(template.to_sym) # for html
      end
    end
  end
end
