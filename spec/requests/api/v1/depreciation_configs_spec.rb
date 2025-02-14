# frozen_string_literal: true

describe '/api/organization/:organization_id/depreciation_config' do
  let(:organization) { create(:organization) }
  let(:url)          { "/api/organizations/#{organization.id}/depreciation_config" }

  describe 'GET #show' do
    subject(:show_resource) { get url, headers: headers }

    let(:resource) { organization.safe_depreciation_config }

    context 'when the user is authorized' do
      include_context 'with admin user headers'

      context 'and the resource exists' do
        it 'returns it' do
          show_resource

          expect(response).to have_http_status(:ok)
          expect(response.headers).to include('access-token')
          expect(json).to match_api_response(resource)
        end
      end
    end

    context 'when the user is not authorized' do
      let(:headers) { api_headers }

      include_examples 'API returns unauthorized'
    end
  end

  describe 'PUT #update' do
    subject(:update_resource) { put url, headers: headers, params: params }

    let(:params)           { { depreciation_method: 'straight_line_depreciation' } }
    let(:incorrect_params) { { depreciation_method: nil } }
    let(:resource)         { organization.depreciation_config }

    context 'when the user is authorized' do
      include_context 'with admin user headers'

      context 'and correct params sent' do
        it 'updates the resource' do
          update_resource

          expect(response).to have_http_status(:ok)
          expect(response.headers).to include('access-token')
          expect(json).to match_api_response(resource.reload)
        end
      end

      context 'and incorrect params sent' do
        let(:params) { try(:incorrect_params) || {} }

        include_examples 'API returns unprocessable entity'
      end
    end

    context 'when the user is not authorized' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:headers) { api_headers }

      include_examples 'API returns unauthorized'
    end
  end
end
