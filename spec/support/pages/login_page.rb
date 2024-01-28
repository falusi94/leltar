# frozen_string_literal: true

class LoginPage < TestPage
  URL = '/session/new'

  def fill_in_login_data(email, password)
    within('#session-form') do
      fill_in 'Email', with: email
      fill_in 'Password', with: password
    end
  end

  def click_login_button
    click_link_or_button 'Sign in'
  end
end
