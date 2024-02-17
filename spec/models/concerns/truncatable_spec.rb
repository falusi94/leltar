# frozen_string_literal: true

describe Truncatable do
  let(:test_class) do
    Struct.new(:attribute, keyword_init: true) do
      extend ActiveModel::Callbacks
      define_model_callbacks :save

      include Truncatable
      truncate_field_before_save :attribute, length: 3

      def save
        run_callbacks :save do
          raise 'Attribute is too long' if attribute.present? && attribute.length > 3
        end

        self
      end
    end
  end

  context 'when the field is blank' do
    it 'throws no error' do
      expect { test_class.new(attribute: nil).save }.not_to raise_error
    end
  end

  context 'when the field is too long' do
    context 'when it has only ascii chars' do
      it 'truncates it' do
        entry = test_class.new(attribute: 'aaaa').save

        expect(entry.attribute.length).to eq(3)
      end
    end

    context 'when it contains unicode chars' do
      it 'truncates it and removes extra characters to compensate the extra space unicode needs' do
        entry = test_class.new(attribute: 'çaaaa').save

        expect(entry.attribute.length).to eq(2)
      end
    end
  end
end
