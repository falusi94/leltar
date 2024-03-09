# frozen_string_literal: true

shared_context 'with admin user headers' do
  let(:user) { create(:admin, :with_session) }
  let(:headers) { auth_headers(user) }
end

shared_examples 'API lists resources' do
  subject(:list_resources) { get url, headers: headers }

  before { resources }

  context 'when the user is authorized' do
    include_context 'with admin user headers'

    it 'returns the resources' do
      list_resources

      expect(response).to have_http_status(:ok)
      expect(response.headers).to include('access-token')
      expect(json).to match_api_response(resources)
    end
  end

  context 'when the user is not authorized' do
    let(:headers) { api_headers }

    include_examples 'API returns unauthorized'
  end
end

shared_examples 'API shows resource' do
  subject(:show_resource) { get "#{url}/#{resource_id}", headers: headers }

  let(:resource_id) { resource.id }

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

    context 'and the resource does not exist' do
      let(:resource_id) { 'non-existing' }

      include_examples 'API returns not found'
    end
  end

  context 'when the user is not authorized' do
    let(:headers) { api_headers }

    include_examples 'API returns unauthorized'
  end
end

shared_examples 'API creates resource' do
  subject(:create_resource) { post url, headers: headers, params: params }

  context 'when the user is authorized' do
    include_context 'with admin user headers'

    context 'and correct params sent' do
      it 'creates the resource' do
        create_resource

        expect(response).to have_http_status(:created)
        expect(response.headers).to include('access-token')
        expect(json).to match_api_response(resource)
      end
    end

    context 'and incorrect params sent' do
      let(:params) { try(:incorrect_params) || {} }

      include_examples 'API returns unprocessable entity'
    end
  end

  context 'when the user is not authorized' do
    let(:headers) { api_headers }

    include_examples 'API returns unauthorized'
  end
end

shared_examples 'API updates resource' do
  subject(:update_resource) { put "#{url}/#{resource_id}", headers: headers, params: params }

  let(:resource_id) { resource.id }

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

    context 'and the resource does not exist' do
      let(:resource_id) { 'non-existing' }

      include_examples 'API returns not found'
    end
  end

  context 'when the user is not authorized' do
    let(:headers) { api_headers }

    include_examples 'API returns unauthorized'
  end
end

shared_examples 'API deletes resource' do
  subject(:delete_resource) { delete "#{url}/#{resource_id}", headers: headers }

  let(:resource_id) { resource.id }

  context 'when the user is authorized' do
    include_context 'with admin user headers'

    context 'and the resource exists' do
      it 'creates the resource' do
        delete_resource

        expect(response).to have_http_status(:no_content)
        expect(response.headers).to include('access-token')
        expect(resource.class).not_to exist(resource.id)
      end
    end

    context 'and the resource does not exist' do
      let(:resource_id) { 'non-existing' }

      include_examples 'API returns not found'
    end
  end

  context 'when the user is not authorized' do
    let(:headers) { api_headers }

    include_examples 'API returns unauthorized'
  end
end
