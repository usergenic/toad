Feature: Project Management
  In order to manage my project
  As a user
  I want to create, list, show, edit and remove my projects

Background:
  Given I am logged in

Scenario: Access the new project form
  Given I am on the "Projects" page
  When I click the "New Project" link
  Then I should be on the "New Project" page

Scenario: Submit the new project form to create a project
  Given there is a project with title "Break eggs"
  And I am on the "New Project" page
  When I fill in "title" with "Make Omelete"
  And I fill in "description" with "Scramble up the goodness"
  And I fill in "dependencies" with tag "Break eggs"
  And I click the "Create" button
  Then I should be on the "Project" page for "Make Omelete"
  And there should be a project with title "Make Omelete" and description "Scramble up the goodness"
  And "Make Omelete" should have dependencies "Break eggs"

