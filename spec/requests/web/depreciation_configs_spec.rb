# frozen_string_literal: true

describe 'Depreciation config' do
  let!(:organization) { create(:organization) }

  describe 'GET #show' do
    subject(:get_depreciation_config) { get "/org/#{organization.slug}/depreciation_config" }

    include_examples 'without user redirects to login'

    it 'returns the depreciation_config' do
      login_admin

      get_depreciation_config

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(organization.safe_depreciation_config.depreciation_frequency_unit)
    end
  end

  describe 'GET #edit' do
    subject(:get_edit_depreciation_config) { get "/org/#{organization.slug}/depreciation_config/edit" }

    include_examples 'without user redirects to login'

    it 'returns the depreciation_config edit page' do
      login_admin

      get_edit_depreciation_config

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(organization.safe_depreciation_config.depreciation_frequency_unit)
    end
  end

  describe 'PUT #update' do
    subject(:update_depreciation_config) do
      put "/org/#{organization.slug}/depreciation_config",
          params: { depreciation_config: { depreciation_frequency_unit: 'week' } }
    end

    include_examples 'without user redirects to login'

    context 'when it is not persisted' do
      it 'creates the organization' do
        login_admin

        expect { update_depreciation_config }.to change(DepreciationConfig, :count).by(1)

        expect(response).to redirect_to(depreciation_config_path(organization))
        expect(organization.depreciation_config.reload).to have_attributes(depreciation_frequency_unit: 'week')
      end
    end

    context 'when it is persisted' do
      it 'creates the organization' do
        login_admin
        organization.safe_depreciation_config.save!

        expect { update_depreciation_config }.not_to change(DepreciationConfig, :count)

        expect(response).to redirect_to(depreciation_config_path(organization))
        expect(organization.depreciation_config.reload).to have_attributes(depreciation_frequency_unit: 'week')
      end
    end
  end
end
