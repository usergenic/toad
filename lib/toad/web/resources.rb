module Toad::Web::Resources

  def path_name_for(page_name)
    page_name.gsub(/([a-z])([A-Z])/, "\\1 \\2").downcase.gsub(" ", "_") + "_path"
  end

  def path_for(page_name, *args)
    send path_name_for(page_name), *args
  end

  def home_path
    "/"
  end

  def first_user_path
    "/first_user"
  end

  def projects_path
    "/projects"
  end

  def project_path(project_id)
    join_path projects_path, project_id
  end

  def new_project_path
    project_path "new"
  end

  def edit_project_path(project_id)
    join_path project_path(project_id), "edit"
  end

  def remove_project_path(project_id)
    join_path project_Path(project_id), "remove"
  end

  def users_path
    "/users"
  end

  def user_path(user_id)
    join_path users_path, user_id
  end

  def new_user_path
    user_path "new"
  end

  def edit_user_path(user_id)
    join_path user_path(user_id), "edit"
  end

  def remove_user_path(user_id)
    join_path user_path(user_id), "remove"
  end

  def join_path(*segments)
    segments.join "/"
  end
end
