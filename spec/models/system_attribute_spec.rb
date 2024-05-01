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
          when :to_i then 1
          when :to_sym then :sym
          when :to_boolean then false
          end
        end

        it { is_expected.to eq(value) }
      end
    end
  end

  describe '.update!' do
    subject(:update) { described_class.update!(params) }

    context 'when the attribute exists' do
      context 'and value is provided' do
        let(:params) { { system_attribute.name => 'new value' } }
        let!(:system_attribute) { create(:system_attribute) }

        it 'updates it' do
          expect { update }.not_to change(described_class, :count)

          expect(system_attribute.reload).to have_attributes(value: 'new value')
        end
      end

      context 'and empty value is provided' do
        let(:params) { { system_attribute.name => '' } }
        let!(:system_attribute) { create(:system_attribute, value: 'value') }

        it 'does nothing it' do
          expect { update }.not_to change(described_class, :count)

          expect(system_attribute.reload).to have_attributes(value: 'value')
        end
      end
    end

    context 'when the attribute does not exist' do
      context 'and the attribute is valid' do
        context 'and value is provided' do
          let(:params) { { described_class::ATTRIBUTES.first => 'new value' } }

          it 'creates it' do
            expect { update }.to change(described_class, :count).by(1)

            expect(described_class.last).to have_attributes(value: 'new value')
          end
        end

        context 'and empty value is provided' do
          let(:params) { { described_class::ATTRIBUTES.first => '' } }

          it 'does nothing it' do
            expect { update }.not_to change(described_class, :count)
          end
        end
      end

      context 'and the attribute is invalid' do
        let(:params) { { invalid: 'new value' } }

        it 'does nothing' do
          expect { update }.not_to change(described_class, :count)
        end
      end
    end
  end
end
