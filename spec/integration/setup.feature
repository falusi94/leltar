Feature: Initial setup

  @setup
  Scenario: Setting up the app without any user and organization
    When open root path
      Then redirect to new_setup_user_path
    When send new user form
      Then create the user
        And log in user
        And redirect to new_setup_organization_path
    When send new organization form
      Then create the organization
        And redirect to root_path
