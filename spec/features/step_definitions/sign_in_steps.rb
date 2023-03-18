# frozen_string_literal: true

steps_for :sign_in do
  step 'fill in login form' do
    @login_page = LoginPage.visit
    @login_page.fill_in_login_data(@user.email, 'password')
  end

  step 'click the login button' do
    @login_page.click_login_button
  end

  step 'the user gets logged in' do
    expect(page).to have_content('LOGOUT')
  end
end
