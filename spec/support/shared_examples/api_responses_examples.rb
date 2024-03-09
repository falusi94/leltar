# frozen_string_literal: true

shared_examples 'API returns unprocessable entity' do
  it 'returns unprocessable entity' do
    subject

    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.headers).to include('access-token')
    expect(json).to include(:errors)
  end
end

shared_examples 'API returns not found' do
  it 'returns not found' do
    subject

    expect(response).to have_http_status(:not_found)
    expect(response.headers).to include('access-token')
  end
end

shared_examples 'API returns unauthorized' do
  it 'returns unauthorized' do
    subject

    expect(response).to have_http_status(:unauthorized)
  end
end
