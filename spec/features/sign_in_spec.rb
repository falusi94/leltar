# frozen_string_literal: true

describe 'the sign-in process' do
  let(:user) { create(:user, password: 'password') }

  it 'signs the user in' do
    login_page = LoginPage.visit

    login_page.fill_in_login_data(user.email, 'password')
    login_page.click_login_button

    expect(page).to have_content('LOGOUT')
  end
end
