# frozen_string_literal: true

describe 'Search' do
  describe 'GET #index' do
    subject(:search) { get '/search' }

    let!(:item) { create(:item) }

    include_examples 'without user redirects to login'

    context 'when the user is admin' do
      before { login_admin }

      it 'returns the result' do
        search

        expect(response).to have_http_status(:ok)
        expect(body).to include(item.name)
      end

      context 'and a search condition is passed' do
        it 'returns the matching results' do
          get '/search', params: { q: { name_cont: 'NOT_MATCHING' } }

          expect(body).not_to include(item.name)
        end
      end

      context 'and export flag is set' do
        it 'returns the csv' do
          get '/search', params: { export_button: 'Export' }

          expect(body).to eq(Item.to_csv)
        end
      end
    end
  end
end
