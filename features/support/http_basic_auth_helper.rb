module HttpBasicAuthHelper

  def authorize(username, password)
    page.driver.browser.basic_authorize(username, password)
  end
end
