# frozen_string_literal: true

describe ItemsQuery do
  subject(:result) { described_class.fetch(filters, scope: scope) }

  let(:filters) { {} }
  let(:scope) { Item }
  let(:items) { create_list(:item, 2) }

  it { is_expected.to match_array(items) }

  context 'when a department_id is set' do
    let(:filters) { { department_id: items.first.department_id } }

    it { is_expected.to contain_exactly(items.first) }
  end

  context 'when a query is set' do
    let(:filters) { { query: items.first.name } }

    it { is_expected.to contain_exactly(items.first) }
  end
end
