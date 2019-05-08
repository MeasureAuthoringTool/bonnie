describe 'CompareVersion', ->
  it 'compares versions correctly', ->
    expect(CompareVersion.compare('1.0', '1.0')).toEqual 0
    expect(CompareVersion.compare('1', '2')).toEqual -1
    expect(CompareVersion.compare('2', '1')).toEqual 1
    expect(CompareVersion.compare('1.0.0.0', '1.0.0.0')).toEqual 0
    expect(CompareVersion.compare('1.0.0', '1.0')).toEqual 0

  it 'correctly identifies newer versions', ->
    expect(CompareVersion.equalToOrNewer('1.0.0', '1.0.0')).toBe true
    expect(CompareVersion.equalToOrNewer('1.0.1', '1.0.0')).toBe true
    expect(CompareVersion.equalToOrNewer('1.0.0', '1.0.1')).toBe false
    expect(CompareVersion.equalToOrNewer('5.3.1', '5.3')).toBe true
