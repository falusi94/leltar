# frozen_string_literal: true

describe StatusPolicy do
  subject { described_class.new(Authorization::Scope.new(user: user), Status) }

  context 'when the user is admin' do
    let(:user) { build_stubbed(:admin) }

    it { is_expected.to permit_action(:index) }
  end

  context 'when the user is not admin' do
    let(:user) { build_stubbed(:user) }

    it { is_expected.to forbid_action(:index) }
  end
end
