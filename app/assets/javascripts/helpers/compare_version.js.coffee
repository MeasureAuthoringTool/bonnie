class CompareVersion
  # code from https://stackoverflow.com/questions/7717109/how-can-i-compare-arbitrary-version-numbers
  @compare: (a, b) ->
    re = /(\.0)+[^\.]*$/
    a = (a + '').replace(re, '').split '.'
    b = (b + '').replace(re, '').split '.'
    len = Math.min a.length, b.length
    for i in [0...len]
      cmp = parseInt(a[i], 10) - parseInt(b[i], 10)
      if( cmp != 0 )
        return cmp
    a.length - b.length

  @equalToOrNewer: (a, b) ->
    0 <= @compare a, b