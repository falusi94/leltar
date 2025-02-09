# frozen_string_literal: true

RSpec.describe LocationDecorator do
  let(:decorated_location) { described_class.decorate(location) }

  let(:location) { build_stubbed(:location) }

  before do
    test_controller = Class.new(ApplicationController) do
      include Authorization::ControllerMixin

      attr_reader :current_user, :current_organization

      def initialize(current_user)
        super()
        @current_user = current_user
      end

      def default_url_options
        { organization_slug: 'organization_slug' }.merge(super)
      end
    end
    Draper::ViewContext.controller = test_controller.new(user)
  end

  describe '#edit_button' do
    subject(:edit_button) { decorated_location.edit_button }

    context 'when the user has access to edit' do
      let(:user) { build_stubbed(:admin) }

      it 'returns the button' do
        expect(edit_button).to be_present.and include("locations/#{location.id}/edit")
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
    subject(:delete_button) { decorated_location.delete_button }

    context 'when the user has access to delete' do
      let(:user) { build_stubbed(:admin) }

      it 'returns the button' do
        expect(delete_button)
          .to be_present.and include("locations/#{location.id}").and include('data-method="delete"')
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
