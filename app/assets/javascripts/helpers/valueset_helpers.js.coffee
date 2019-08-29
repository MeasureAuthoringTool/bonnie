###*
# Contains helpers related to the processing and analysis of valuesets
###
@ValueSetHelpers = class ValueSetHelpers
  ###*
  # Uses format of OID to determine if valueset is a direct reference code.
  # Regular valuesets OIDs have the format "#.#.#.#"
  # Whereas Direct Reference Codes have GUIDS of the fomrat "#-#-#-#"
  # @public
  # @param {String} oid - The oid or guid of the valueset.
  # @return {Boolean} True if valueset is direct reference code, else false.
  ###
  @isDirectReferenceCode: (oid) ->
    for char in oid
      # Return as soon as we find a '-' or '.'
      if char is '-'
        return true
      if char is '.'
        return false

