# frozen_string_literal: true

shared_examples 'the record is valid' do
  it 'is valid' do
    expect(subject).to be_valid
  end
end

shared_examples 'the record is invalid' do
  it 'is invalid' do
    expect(subject).to be_invalid
  end
end
