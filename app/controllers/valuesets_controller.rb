class ValuesetsController < ApplicationController

  def update
    valueSet = HealthDataStandards::SVS::ValueSet.find(params[:id])
    valueSetConcepts = valueSet.concepts
    valueSetConcepts.each_with_index do |concept, index|
      newConcept = params[:concepts][index]
      if concept['white_list'] != newConcept[:white_list] || concept['black_list'] != newConcept[:black_list]
        concept['white_list'] = newConcept[:white_list]
        concept['black_list'] = newConcept[:black_list]
      end
    end
    valueSet.concepts = valueSetConcepts
    valueSet.save!
    render :json => valueSet
  end

end