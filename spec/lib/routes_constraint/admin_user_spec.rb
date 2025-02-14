# frozen_string_literal: true

describe RoutesConstraint::AdminUser do
  subject(:admin_user) do
    request = instance_double(ActionDispatch::Request, session: session)

    described_class.matches?(request)
  end

  context 'when the session is empty' do
    let(:session) { {} }

    it { is_expected.to be(false) }
  end

  context 'when the session is present' do
    let(:session) { { user_id: user.id } }

    context 'and the user is not admin' do
      let(:user) { create(:user) }

      it { is_expected.to be(false) }
    end

    context 'and the user is admin' do
      let(:user) { create(:admin) }

      it { is_expected.to be(true) }
    end
  end
end
