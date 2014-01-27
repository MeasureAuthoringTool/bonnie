class ValuesetsController < ApplicationController

  def update
    valueSet = HealthDataStandards::SVS::ValueSet.find(params[:id])
    # params[:concepts].each do |newConcept|
    #   concept = valueSet.concepts.find(newConcept[:_id])
    #   if concept['white_list'] != newConcept[:white_list] || concept['black_list'] != newConcept[:black_list]
    #     concept.update_attributes({id: valueSet.id, white_list: newConcept[:white_list], black_list: newConcept[:black_list]})
    #     concept.save!
    #   end
    #   # 
    #   # 
    # end
    # valueSet.save!
    valueSetConcepts = valueSet.concepts
    valueSetConcepts.each_with_index do |concept, index|
      newConcept = params[:concepts][index]
      # binding.pry
      if concept['white_list'] != newConcept[:white_list] || concept['black_list'] != newConcept[:black_list]
        concept['white_list'] = newConcept[:white_list]
        concept['black_list'] = newConcept[:black_list]
      end
      # binding.pry
    end
    # binding.pry
    valueSet.concepts = valueSetConcepts
    valueSet.save!
    render :json => valueSet
  end

end