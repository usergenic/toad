Feature: Project Path
  In order to figure out what it will take to complete a project
  As a user
  I want to see the full lineage of dependencies leading to a project

Background:
  Given I am logged in

Scenario: Path contains just the goal, when there are no dependencies
  Given there is a project with title "Z"
  When I visit the "Project" page for "Z"
  Then I should see the "path" table
    | Z |

Scenario: Dependencies precede goal
  Given there is a project with title "A"
  And there is a project with title "B"
  And there is a project with title "Z"
  And "Z" has dependencies "A" and "B"
  When I visit the "Project" page for "Z"
  Then I should see the "path" table
    | A |
    | B |
    | Z |

Scenario: Dependencies of dependencies should be followed
  Given there is a project with title "A"
  And there is a project with title "B"
  And there is a project with title "Before B"
  And there is a project with title "Goal"
  And "Goal" has dependencies "A" and "B"
  And "B" has dependencies "Before B"
  When I visit the "Project" page for "Goal"
  Then I should see the "path" table
    | A        |
    | Before B |
    | B        |
    | Goal     |

Scenario: Dependencies are shown only once in the path
  Given there is a project with title "A"
  And there is a project with title "Shared Dependency"
  And there is a project with title "B"
  And there is a project with title "C"
  And there is a project with title "Goal"
  And "Goal" has dependencies "A" and "B"
  And "A" has dependencies "Shared Dependency"
  And "B" has dependencies "Shared Dependency"
  And "Shared Dependency" has dependencies "C"
  When I visit the "Project" page for "Goal"
  Then I should see the "path" table
    | C                 |
    | Shared Dependency |
    | A                 |
    | B                 |
    | Goal              |

Scenario: Circular dependencies
