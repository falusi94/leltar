# frozen_string_literal: true

describe SystemAttribute do
  describe '.new_session_start' do
    subject(:new_session_start) { described_class.new_session_start }

    context 'when the attribute is not set' do
      it 'returns nil' do
        expect(new_session_start).to be nil
      end
    end

    context 'when the attribute is set' do
      it 'returns the parsed date' do
        create(:new_session_start_attribute)

        expect(new_session_start).to eq(Time.zone.today)
      end
    end
  end
end
