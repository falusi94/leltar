# frozen_string_literal: true

describe ItemsQuery do
  subject(:result) { described_class.fetch(filters, scope: scope) }

  let(:filters) { {} }
  let(:scope) { Item }
  let(:items) { create_list(:item, 2) }

  it { is_expected.to match_array(items) }

  context 'when a group_id is set' do
    let(:filters) { { group_id: items.first.group_id } }

    it { is_expected.to contain_exactly(items.first) }
  end

  context 'when a query is set' do
    let(:filters) { { query: items.first.name } }

    it { is_expected.to contain_exactly(items.first) }
  end
end
