Feature: User signs in

  @common_steps @sign_in
  Scenario: A registered user signs in successfully
    Background:
      Given a user
    When the user visits '/session/new'
      And fill in login form
      And click the login button
    Then the user gets logged in
