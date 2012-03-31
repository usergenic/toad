Given("I am logged in") do
  step 'there is a user with username "alice" and password "wndrlnd"'
  authorize "alice", "wndrlnd"
end

Given(/^I am on the "([^"]*)" page$/) { |page| visit path_for(page) }
When(/^I visit the "([^"]*)" page$/) { |page| visit path_for(page) }
When(/^I fill in "([^"]*)" with "([^"]*)"$/) { |name, value| fill_in name, with: value }
When(/^I fill in "([^"]*)" with tags? (.*)$/) { |name, tags| fill_in name, with: tags.scan(/"([^"]+)"(?: and )?/).to_json }
When(/^I click the "([^"]*)" button$/) { |name| click_button name }
When(/^I click the "([^"]*)" link$/) { |name| click_link name }
Then(/^I should be on the "([^"]*)" page$/) { |name| page.current_path.should == path_for(name) }
Then("I should be prompted for my username and password") { page.status_code.should == 401 }
