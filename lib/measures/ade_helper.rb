module Measures
  class ADEHelper

    ADE_SET_ID='A5E96A45-8132-4E72-BF4F-E8C81DB9E641'
    ADE_PRE_V4_ID=['40280381-454E-C5FA-0145-517F7383016D']

    ADE_FIELDS_POST_V4 = {custom_functions: {MSRPOPL: 'hqmf.CustomCalc.ADE_TTR_MSRPOPL',OBSERV: 'hqmf.CustomCalc.ADE_TTR_OBSERV'},
                  force_sources: ['LaboratoryTestPerformedInr']}
    ADE_FIELDS_PRE_V4 = {custom_functions: {MSRPOPL: 'hqmf.CustomCalc.ADE_TTR_MSRPOPL',OBSERV: 'hqmf.CustomCalc.ADE_TTR_OBSERV'},
                  force_sources: ['LaboratoryTestResultInr']}
    
    def self.update_if_ade(measure)
      if (measure.hqmf_set_id == ADE_SET_ID)
        if (ADE_PRE_V4_ID.include? measure.hqmf_id)
          measure.update_attributes(ADE_FIELDS_PRE_V4)
        else
          measure.update_attributes(ADE_FIELDS_POST_V4)
        end
      end
    end

  end
end