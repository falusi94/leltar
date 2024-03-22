# frozen_string_literal: true

describe SystemAttribute do
  described_class::MAPPING.each do |name, transformer|
    describe ".#{name}" do
      subject { described_class.public_send(name) }

      context 'when the attribute is not set' do
        it { is_expected.to be(nil) }
      end

      context 'when the attribute is set' do
        before { create(:system_attribute, name: name, value: value) }

        let(:value) do
          case transformer
          when :to_date then Time.zone.today
          end
        end

        it { is_expected.to eq(value) }
      end
    end
  end
end
