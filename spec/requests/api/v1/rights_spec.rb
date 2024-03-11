# frozen_string_literal: true

describe '/api/rights' do
  let(:url) { '/api/rights' }

  describe 'POST #create' do
    let(:params)   { { group_id: create(:group).id, user_id: create(:user).id } }
    let(:resource) { Right.last }

    include_examples 'API creates resource'
  end

  describe 'PUT #update' do
    let(:params)           { { write: true } }
    let(:incorrect_params) { { group_id: nil } }
    let(:resource)         { create(:right) }

    include_examples 'API updates resource'
  end

  describe 'DELETE #destroy' do
    let(:resource) { create(:right) }

    include_examples 'API deletes resource'
  end
end
