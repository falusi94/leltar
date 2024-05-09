# frozen_string_literal: true

RSpec.describe OrganizationDecorator do
  let(:decorated_organization) { described_class.decorate(organization) }

  let(:organization) { build_stubbed(:organization) }

  before do
    test_controller = Class.new(ApplicationController) do
      attr_reader :current_user

      def initialize(current_user)
        super()
        @current_user = current_user
      end
    end
    Draper::ViewContext.controller = test_controller.new(user)
  end

  describe '#edit_button' do
    subject(:edit_button) { decorated_organization.edit_button }

    context 'when the user has access to edit' do
      let(:user) { build_stubbed(:admin) }

      it 'returns the button' do
        expect(edit_button).to be_present.and include("organizations/#{organization.id}/edit")
      end
    end

    context 'when the user has no access to edit' do
      let(:user) { build_stubbed(:user) }

      it 'returns the button' do
        expect(edit_button).to be(nil)
      end
    end
  end

  describe '#delete_button' do
    subject(:delete_button) { decorated_organization.delete_button }

    context 'when the user has access to delete' do
      let(:user) { build_stubbed(:admin) }

      it 'returns the button' do
        expect(delete_button)
          .to be_present.and include("organizations/#{organization.id}").and include('data-method="delete"')
      end
    end

    context 'when the user has no access to delete' do
      let(:user) { build_stubbed(:user) }

      it 'returns the button' do
        expect(delete_button).to be(nil)
      end
    end
  end
end
