module HQMF
  class Coded
    # Select the relevant value set that matches the given OID and generate a hash that can be stored on a Record.
    # The hash will be of this format: { "code_set_identified" => [code] }
    #
    # @param [String] oid The target value set.
    # @param [Hash] value_sets Value sets that might contain the OID for which we're searching.
    # @return A Hash of code sets corresponding to the given oid, each containing one randomly selected code.
    def self.select_codes(oid, value_sets)
      value_sets = HQMF::Coded.select_value_sets(oid, value_sets)
      code_sets = {}
      value_sets["concepts"].each do |concept|
        code_sets[concept["code_system_name"]] ||= [concept["code"]]
      end
      code_sets
    end
    
    # Filter through a list of value sets and choose only the ones marked with a given OID.
    #
    # @param [String] oid The OID being used for filtering.
    # @param [Array] value_sets A pool of available value sets
    # @return The value set from the list with the requested OID.
    def self.select_value_sets(oid, value_sets)
      # Pick the value set for this DataCriteria. If it can't be found, it is an error from the value set source. We'll add the entry without codes for now.
      index = value_sets.index{|value_set| value_set["oid"] == oid}
      value_sets = index.nil? ? { "concepts" => [] } : value_sets[index]
      value_sets
    end

    # Select the relevant value set that matches the given OID and generate a hash that can be stored on a Record.
    # The hash will be of this format: { "codeSystem" => "code_set_identified", "code" => code }
    #
    # @param [String] oid The target value set.
    # @param [Hash] value_sets Value sets that might contain the OID for which we're searching.
    # @return A Hash including a code and code system containing one randomly selected code.
    def self.select_code(oid, value_sets)
      codes = select_codes(oid, value_sets)
      code_system = codes.keys()[0]
      return nil if code_system.nil?
      {
        'code_system' => code_system,
        'code' => codes[code_system][0]
      }
    end
  end
end