@ArrayHelpers = class ArrayHelpers
  @chunk: (array, size) ->
    if array.length == 0
      return []
    else
      return [array.splice(0, size)].concat(@chunk(array, size))
