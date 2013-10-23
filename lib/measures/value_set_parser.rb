module HQMF
  module ValueSet
    class Parser

      attr_accessor :child_oids
      attr_accessor :parent_oids
  
      GROUP_CODE_SET = "GROUPING"
  
      ORGANIZATION_INDEX = 0
      OID_INDEX = 1
      CONCEPT_INDEX = 3
      CATEGORY_INDEX = 4
      CODE_SET_INDEX =5
      VERSION_INDEX = 6
      CODE_INDEX = 7
      DESCRIPTION_INDEX = 8
 
      DEFAULT_SHEET = 1
      SUPPLEMENTAL_SHEET = 2

      CODE_SYSTEM_NORMALIZER = {
        'ICD-9'=>'ICD-9-CM',
        'ICD-10'=>'ICD-10-CM',
        'HL7 (2.16.840.1.113883.5.1)'=>'HL7'
      }
      IGNORED_CODE_SYSTEM_NAMES = ['Grouping', 'GROUPING' ,'HL7', "Administrative Sex", 'CDC']
  
      # import an excel matrix array into mongo
      def parse(file)
        @value_set_models = {}
        extract_value_sets(file, DEFAULT_SHEET)
        extract_value_sets(file, SUPPLEMENTAL_SHEET)
        @value_set_models.values
      end

      def self.book_by_format(file_path)
        if file_path =~ /xls$/
          Roo::Excel.new(file_path, nil, :ignore)
        elsif file_path =~ /xlsx$/
          Roo::Excelx.new(file_path, nil, :ignore)
        else
          raise "File: #{file_path} does not end in .xls or .xlsx"
        end
      end

      private
  
      # Break all the supplied strings into separate words and return the resulting list as a
      # new string with each word separated with '_'
      def normalize_names(*components)
        name = []
        components.each do |component|
          component ||= ''
          name.concat component.gsub(/\W/,' ').split.collect { |word| word.strip.downcase }
        end
        name.join '_'
      end
      
      def normalize_code_system(code_system_name)
        code_system_name = CODE_SYSTEM_NORMALIZER[code_system_name] if CODE_SYSTEM_NORMALIZER[code_system_name]
        return code_system_name if IGNORED_CODE_SYSTEM_NAMES.include? code_system_name
        oid = HealthDataStandards::Util::CodeSystemHelper.oid_for_code_system(code_system_name)
        puts "\tbad code system name: #{code_system_name}" unless oid
        code_system_name
      end
  
      # turn a single cpt code range into a set of codes, otherwise return the code as an array
      def extract_code(code, set)
        code.strip!
        if set=='CPT' && code.include?('-')
          eval(code.strip.gsub('-','..')).to_a.collect { |i| i.to_s }
        else
          [code]
        end
      end
  
      # pull all the value sets and fill out the parents
      def extract_value_sets(file_path, sheet_index)

        @child_oids = Set.new
        @parent_oids = Set.new

        book = HQMF::ValueSet::Parser.book_by_format(file_path)
        book.default_sheet=book.sheets[sheet_index]

        (2..book.last_row).each do |row_index|
          extract_row(book.row(row_index))
        end

        fill_out_parents

      end

      # turn a row array into a value set model stored in @value_set_models
      # parents still need to be filled out after the fact
      def extract_row(row)

        oid = row[OID_INDEX].strip.gsub(/[^0-9\.]/i, '')

        # skip rows with no oid
        return if oid.nil? || oid.empty?

        existing_vs = @value_set_models[oid]

        version = row[VERSION_INDEX]
        if existing_vs.nil?
          display_name = normalize_names(row[CATEGORY_INDEX],row[CONCEPT_INDEX]).titleize
          existing_vs = HealthDataStandards::SVS::ValueSet.new({oid: oid, display_name: display_name, version: version ,concepts: []})
          @value_set_models[oid] = existing_vs
        end

        codes = extract_code(row[CODE_INDEX].to_s, row[CODE_SET_INDEX])
        code_system_name = normalize_code_system(row[CODE_SET_INDEX])
        description = row[DESCRIPTION_INDEX]

        codes.each do |code|
          concept = HealthDataStandards::SVS::Concept.new({code: code, code_system_name: code_system_name, code_system_version: version, display_name: description})
          existing_vs.concepts << concept
        end

        if (code_system_name.upcase == GROUP_CODE_SET)
          @parent_oids << oid
        else
          @child_oids << oid
        end
      end
  
      def fill_out_parents
        @parent_oids.each do |parent_oid|
          parent_vs = @value_set_models[parent_oid]
          concepts = parent_vs.concepts.map do |c| 
            if @value_set_models[c.code]
              @value_set_models[c.code].concepts
            else
              puts "\tParent #{parent_oid} is missing child oid: #{c.code}"
              []
            end
          end
          parent_vs.concepts = concepts.flatten!
        end
      end

  
    end
  end
end
