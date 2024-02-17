# frozen_string_literal: true

describe RoutesConstraint::ApiVersion do
  subject(:version_matches) do
    request = instance_double(ActionDispatch::Request, headers: headers.with_indifferent_access)

    api_version.matches?(request)
  end

  let(:api_version) { described_class.new(version: version, default: default) }

  let(:default) { false }
  let(:version) { 1 }
  let(:headers) { {} }

  context 'when contains no matching header' do
    let(:default) { true }

    it 'returns default value' do
      expect(version_matches).to be(true)
    end
  end

  context 'when the a maching header is sent' do
    context 'with the correct version' do
      let(:headers) { { Accept: 'application/vnd.leltar.api-v1+json' } }

      it { is_expected.to be(true) }
    end

    context 'with the incorrect version' do
      let(:headers) { { Accept: 'application/vnd.leltar.api-v0+json' } }

      it { is_expected.to be(false) }
    end
  end
end
