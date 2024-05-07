# frozen_string_literal: true

describe OrganizationPolicy do
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

    it { is_expected.to permit_action(:index)   }
    it { is_expected.to forbid_action(:show)    }
    it { is_expected.to forbid_action(:edit)    }
    it { is_expected.to forbid_action(:create)  }
    it { is_expected.to forbid_action(:update)  }
    it { is_expected.to forbid_action(:destroy) }
  end

  describe 'permitted attributes' do
    subject(:permitted_attributes) { described_class.new('user', 'WHATEVER').permitted_attributes }

    it 'excludes admin params' do
      expect(permitted_attributes).to match(%i[name slug currency_code fiscal_period_starts_at fiscal_period_unit])
    end
  end
end
