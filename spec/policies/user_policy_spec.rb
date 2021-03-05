# frozen_string_literal: true

describe UserPolicy do
  subject { described_class.new(current_user, user) }

  let(:user) { build_stubbed(:user) }

  context 'when the user is admin' do
    let(:current_user) { build_stubbed(:admin) }

    it { is_expected.to permit_action(:index)   }
    it { is_expected.to permit_action(:show)    }
    it { is_expected.to permit_action(:edit)    }
    it { is_expected.to permit_action(:create)  }
    it { is_expected.to permit_action(:update)  }
    it { is_expected.to permit_action(:destroy) }
  end

  context 'when the user is not admin' do
    let(:current_user) { build_stubbed(:user) }

    it { is_expected.to forbid_action(:index)   }
    it { is_expected.to forbid_action(:show)    }
    it { is_expected.to forbid_action(:edit)    }
    it { is_expected.to forbid_action(:create)  }
    it { is_expected.to forbid_action(:update)  }
    it { is_expected.to forbid_action(:destroy) }

    context 'and it is the current user' do
      let(:current_user) { user }

      it { is_expected.to permit_action(:edit)    }
      it { is_expected.to permit_action(:update)  }
    end
  end
end
