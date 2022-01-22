# frozen_string_literal: true

describe 'Rights' do
  describe 'POST #create' do
    subject(:create_right) { post '/rights', params: { right: { user_id: user.id, group_id: group.id } } }

    let(:group) { create(:group) }
    let(:user) { create(:user) }

    include_examples 'without user redirects to login'

    context 'when the user is admin' do
      it 'adds the right' do
        login_admin

        expect { create_right }.to change(Right, :count).by(1)

        expect(Right.last).to have_attributes(user: user, group: group)
      end
    end
  end

  describe 'PUT #update' do
    subject(:update_right) { put "/rights/#{right.id}" }

    let(:right) { create(:read_right) }

    include_examples 'without user redirects to login'

    context 'when the user is admin' do
      it 'toggles the write flag' do
        login_admin

        update_right

        expect(right.reload).to have_attributes(write: true)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject(:delete_right) { delete "/rights/#{right.id}" }

    let!(:right) { create(:read_right) }

    include_examples 'without user redirects to login'

    context 'when the user is admin' do
      it 'toggles the write flag' do
        login_admin

        expect { delete_right }.to change(Right, :count).by(-1)
      end
    end
  end
end
