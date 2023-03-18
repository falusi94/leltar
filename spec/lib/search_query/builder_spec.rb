# frozen_string_literal: true

describe SearchQuery::Builder do
  let(:scope) { Item }

  describe 'matching' do
    context 'when the query string matches' do
      it 'returns the object' do
        user = create(:item, name: 'TEST')

        result = described_class.run('TEST', fields: [:name], scope: scope)

        expect(result).to include(user)
      end
    end

    context 'when the query string partially matches' do
      it 'returns the object' do
        user = create(:item, name: 'TEST')

        result = described_class.run('ES', fields: [:name], scope: scope)

        expect(result).to include(user)
      end
    end
  end

  describe 'case-insensitivity' do
    context 'when the query string matches' do
      context 'and the query string is lower case while the attribute upper' do
        it 'returns the object' do
          user = create(:item, name: 'TEST')

          result = described_class.run('test', fields: [:name], scope: scope)

          expect(result).to include(user)
        end
      end

      context 'and the query string is upper case while the attribute lower' do
        it 'returns the object' do
          user = create(:item, name: 'test')

          result = described_class.run('TEST', fields: [:name], scope: scope)

          expect(result).to include(user)
        end
      end
    end
  end

  describe 'searching by different fields' do
    context 'when the query string matches a provided field' do
      it 'returns the object' do
        user = create(:item, name: 'TEST')

        result = described_class.run('TEST', fields: [:name], scope: scope)

        expect(result).to include(user)
      end
    end

    context 'when the query string matches a not provided field' do
      it 'does not return the object' do
        user = create(:item, specific_name: 'TEST')

        result = described_class.run('TEST', fields: [:name], scope: scope)

        expect(result).not_to include(user)
      end
    end
  end

  describe 'transliterate of query' do
    context 'when the transliterated query string matches' do
      it 'returns the object' do
        user = create(:item, name: 'TEST')

        result = described_class.run('TÉŠT', fields: [:name], scope: scope)

        expect(result).to include(user)
      end
    end
  end

  describe 'pagination over the result' do
    before { create_list(:item, 4, name: 'TEST') }

    describe 'by offset param' do
      context 'when no offset provided' do
        it 'returns the first two elements' do
          result = described_class.run('TEST', fields: [:name], scope: scope, count: 2)

          expect(result).to match([scope.first, scope.second])
        end
      end

      context 'when offset is provided' do
        it 'returns the elements shifted by the offset' do
          result = described_class.run('TEST', fields: [:name], scope: scope, offset: 1, count: 2)

          expect(result).to match([scope.second, scope.third])
        end
      end
    end

    describe 'by page param' do
      context 'when no page provided' do
        it 'returns the first two elements' do
          result = described_class.run('TEST', fields: [:name], scope: scope, count: 2)

          expect(result).to match([scope.first, scope.second])
        end
      end

      context 'when page is provided' do
        it 'returns the elements of the given page' do
          result = described_class.run('TEST', fields: [:name], scope: scope, page: 2, count: 2)

          expect(result).to match([scope.third, scope.fourth])
        end
      end
    end

    context 'when the count is set to -1' do
      it 'returns all elements' do
        result = described_class.run('TEST', fields: [:name], scope: scope, count: -1)

        expect(result.count).to eq 4
      end
    end
  end
end
