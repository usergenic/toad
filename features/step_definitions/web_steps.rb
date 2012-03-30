Given(/^I am on the "([^"]*)" page$/) { |page| visit path_for(page) }
When(/^I visit the "([^"]*)" page$/) { |page| visit path_for(page) }
When(/^I fill in "([^"]*)" with "([^"]*)"$/) { |name, value| fill_in name, :with => value }
When(/^I click the "([^"]*)" button$/) { |name| click_button name }
Then(/^I should be on the "([^"]*)" page$/) { |name| page.current_path.should == path_for(name) }
Then("I should be prompted for my username and password") { page.status_code.should == 401 }


