describe 'ValueSetHelpers', ->
  describe 'isDirectReferenceCode', ->
    it 'returns true if direct reference code', ->
      expect(ValueSetHelpers.isDirectReferenceCode('1-1-1-1-1')).toBe true

    it 'returns false if not reference code', ->
      expect(ValueSetHelpers.isDirectReferenceCode('1.1.1.1.1')).toBe false
