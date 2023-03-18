# frozen_string_literal: true

steps_for :common_steps do
  step 'the user visits :url' do |url|
    visit url
  end

  step 'a user' do
    @user = create(:user)
  end
end
