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
  And I fill in "tags" with tag "Breakfast"
  And I click the "Create" button
  Then I should be on the "Project" page for "Make Omelete"
  And there should be a project with title "Make Omelete" and description "Scramble up the goodness"
  And "Make Omelete" should have dependencies "Break eggs"
  And "Make Omelete" should have tags "Breakfast"

Scenario: View a project
  Given there is a project with title "Chop down trees"
  And there is a project with title "Assemble log cabin" and description "Stack and fasten logs"
  And "Assemble log cabin" has dependencies "Chop down trees"
  When I visit the "Project" page for "Assemble log cabin"
  Then I should see the title text "Assemble log cabin"
  And I should see the description text "Stack and fasten logs"
  And I should see the dependency text "Chop down trees"

Scenario: Access the edit project page
  Given there is a project with title "Build-a-Bear"
  And I am on the "Project" page for "Build-a-Bear"
  When I click the "Edit" link
  Then I should be on the "Edit Project" page for "Build-a-Bear"

Scenario: Submit the edit project form to update a project
  Given there is a project with title "Super Project"
  And there is a project with title "Duper Project"
  And there is a project with title "Looper Project"
  And there is a project with title "Scooper Project"
  And "Super Project" has dependencies "Duper Project" and "Looper Project"
  And I am on the "Edit Project" page for "Super Project"
  When I fill in "title" with "Hooper Project"
  And I fill in "description" with "Hoop-a-doop!"
  And I fill in "dependencies" with tags "Looper Project" and "Scooper Project"
  And I fill in "tags" with tags "Awesome" and "Really Awesome"
  And I click the "Save Changes" button
  Then I should be on the "Project" page for "Hooper Project"
  And "Hooper Project" should have dependencies "Looper Project" and "Scooper Project"
  And "Hooper Project" should have tags "Awesome" and "Really Awesome"
  And there should not be a project with title "Super Project"

Scenario: Remove project link directs to a confirmation page
  Given there is a project with title "Mission to the Sun"
  And I am on the "Project" page for "Mission to the Sun"
  When I click the "Remove Project" link
  Then I should be on the "Remove Project" page for "Mission to the Sun"

Scenario: Remove project by clicking the yes button on confirmation page
  Given there is a project with title "This Project Sucks"
  And I am on the "Remove Project" page for "This Project Sucks"
  When I click the "Yes, I am absolutely sure" button
  Then I should be on the "Projects" page
  And there should not be a project with title "This Project Sucks"
