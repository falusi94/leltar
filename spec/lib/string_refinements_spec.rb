# frozen_string_literal: true

RSpec.describe StringRefinements do
  using described_class

  describe '#to_boolean' do
    subject(:casted_value) { value.to_boolean }

    let(:boolean) { ActiveModel::Type::Boolean.new }

    before do
      allow(boolean).to receive(:cast).and_call_original
      allow(ActiveModel::Type::Boolean).to receive(:new).and_return(boolean)
    end

    context 'when it is true' do
      let(:value) { 'true' }

      it 'returns true' do
        expect(casted_value).to be(true)

        expect(boolean).to have_received(:cast).with(value)
      end
    end

    context 'when it is false' do
      let(:value) { 'false' }

      it 'returns false' do
        expect(casted_value).to be(false)

        expect(boolean).to have_received(:cast).with(value)
      end
    end
  end
end
