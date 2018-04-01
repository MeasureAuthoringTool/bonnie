class VsacUtilController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def profile_names
    api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'])
    profile_names = api.get_profile_names
    # add in the pseudo program
    profile_names.insert(1, 'Latest eCQM')
    render :json => { profileNames: profile_names }
  end

  def program_names
    api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'])
    render :json => { programNames: api.get_program_names }
  end
  
  def program_release_names
    api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'])

    begin
      response = {
        programName: params[:program],
        releaseNames: api.get_program_release_names(params[:program])
      }
      render :json => response
    rescue Util::VSAC::VSACProgramNotFoundError
      render :json => { error: 'Program not found.' }, :status => 404
    end
  end
end
