# frozen_string_literal: true

describe 'Item status check' do
  describe 'POST #create' do
    subject(:status_check) do
      post "/org/#{item.organization.slug}/items/#{item.id}/status_check",
           params: { item: { status: 'not_found', condition: 'end_of_life' } }
    end

    let(:item) { create(:item, last_check: 3.days.ago) }

    include_examples 'without user redirects to login'

    it 'returns the version' do
      login_admin

      status_check

      expect(response).to redirect_to(item)
      expect(item.reload).to be_status_not_found.and be_condition_end_of_life.and have_attributes(
        last_check: Time.zone.today
      )
    end
  end
end
