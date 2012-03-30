Feature: First user to the system gets to create the master account
  In order to start using a fresh system
  As a user
  I want to create an account

Scenario: A Toad app with no users prompts to create one
  Given there are no users
  When I visit the "Home" page
  Then I should be on the "First User" page

Scenario: I create the first user by submitting the First User form
  Given there are no users
  And I am on the "First User" page
  When I fill in "username" with "brendan"
  And I fill in "password" with "shh!"
  And I click the "Create" button
  Then there should be a user with username "brendan" and password "shh!"
  And I should be prompted for my username and password

