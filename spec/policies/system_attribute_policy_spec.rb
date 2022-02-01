# frozen_string_literal: true

describe SystemAttributePolicy do
  subject { described_class.new(user, SystemAttribute) }

  context 'when the user is admin' do
    let(:user) { build_stubbed(:admin) }

    it { is_expected.to permit_action(:edit)   }
    it { is_expected.to permit_action(:update) }
  end

  context 'when the user is not admin' do
    let(:user) { build_stubbed(:user) }

    it { is_expected.to forbid_action(:edit)   }
    it { is_expected.to forbid_action(:update) }
  end
end
