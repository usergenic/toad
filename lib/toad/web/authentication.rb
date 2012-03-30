module Toad::Web::Authentication

  def auth
    @auth ||= Rack::Auth::Basic::Request.new(request.env)
  end

  def basic_auth_provided?
    auth.provided? and auth.basic?
  end

  def current_user
    @current_user ||= find_user_from_basic_auth_credentials
  end

  def find_user_from_basic_auth_credentials
    return unless basic_auth_provided?
    Toad::Models::User.find_by_username_and_password(*auth.credentials)
  end

  def require_authentication!
    return if current_user

    # Access Denied sucks because it is inconvenient to retry in most browsers
    # after invalid username/password provided.

    response["WWW-Authenticate"] = %{Basic realm="Authorized Users Only"}

    throw :halt, [403, "Access denied\n"] if basic_auth_provided?
    throw :halt, [401, "Not authorized\n"]
  end
end
