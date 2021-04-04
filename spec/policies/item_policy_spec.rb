# frozen_string_literal: true

describe ItemPolicy do
  subject { described_class.new(user, item) }

  let(:item) { build_stubbed(:item) }

  context 'when the user is admin' do
    let(:user) { build_stubbed(:admin) }

    it { is_expected.to permit_action(:edit) }
  end

  context 'when the user is not admin' do
    let(:user) { build_stubbed(:user) }

    it { is_expected.to forbid_action(:edit) }
  end
end
