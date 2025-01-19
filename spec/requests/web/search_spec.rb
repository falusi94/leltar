# frozen_string_literal: true

describe 'Search' do
  let!(:organization) { create(:organization) }

  describe 'GET #index' do
    subject(:search) { get "/org/#{organization.slug}/search", params: try(:params) }

    let!(:item) { create(:item, organization: organization) }

    include_examples 'without user redirects to login'

    context 'when the user is admin' do
      before { login_admin }

      it 'returns the result' do
        search

        expect(response).to have_http_status(:ok)
        expect(body).to include(item.name)
      end

      context 'and a search condition is passed' do
        let(:params) { { q: { name_cont: 'NOT_MATCHING' } } }

        it 'returns the matching results' do
          search

          expect(body).not_to include(item.name)
        end
      end

      context 'and export flag is set' do
        let(:params) { { export_button: 'Export' } }

        it 'returns the csv' do
          search

          expect(body).to eq(Item.to_csv)
        end
      end
    end
  end
end
