# frozen_string_literal: true

describe GroupPolicy do
  subject { described_class.new(user, group) }

  let(:group) { build_stubbed(:group) }

  context 'when the user is admin' do
    let(:user) { build_stubbed(:admin) }

    it { is_expected.to permit_action(:index)   }
    it { is_expected.to permit_action(:show)    }
    it { is_expected.to permit_action(:edit)    }
    it { is_expected.to permit_action(:create)  }
    it { is_expected.to permit_action(:update)  }
    it { is_expected.to permit_action(:destroy) }
  end

  context 'when the user is not admin' do
    let(:user) { build_stubbed(:user) }

    it { is_expected.to permit_action(:index)   }
    it { is_expected.to forbid_action(:show)    }
    it { is_expected.to forbid_action(:edit)    }
    it { is_expected.to forbid_action(:create)  }
    it { is_expected.to forbid_action(:update)  }
    it { is_expected.to forbid_action(:destroy) }
  end
end
