# frozen_string_literal: true

steps_for :setup do
  attr_reader :user_params, :organization_params

  step 'open root path' do
    get '/'
  end

  step 'redirect to :path' do |path|
    expected_path = Rails.application.routes.url_helpers.public_send(path)

    expect(response).to redirect_to(expected_path)
  end

  step 'send new user form' do
    @user_params = { name: 'Setup User', email: 'setup@example.org', password: '1234', password_confirmation: '1234' }

    post '/setup/users', params: { user: user_params }
  end

  step 'create the user' do
    expected_attributes = user_params.except(:password, :password_confirmation).merge(admin: true)

    expect(User.last).to be_present.and have_attributes(expected_attributes)
  end

  step 'log in user' do
    expect(session[:user_id]).to eq(User.last.id)
  end

  step 'send new organization form' do
    @organization_params = { name: 'Setup Organization', slug: 'setup', currency_code: 'EUR' }

    post '/setup/organizations', params: { organization: organization_params }
  end

  step 'create the organization' do
    expect(Organization.last).to be_present.and have_attributes(organization_params)
  end
end
