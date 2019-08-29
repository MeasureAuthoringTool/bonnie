##
# Utility calls for VSAC operations. Provides the frontend access to VSAC program, release and profile lists as well
# as ticket granting ticket status.
class VsacUtilController < ApplicationController
  before_action :authenticate_user!
  respond_to :json

  ##
  # GET /vsac_util/profile_names
  #
  # Gets the list of profile names from VSAC and returns in JSON the following object to contain the list and which
  # profile is that latest one for the defualt program:
  # { profileNames: Array<String>, latestProfile: String }
  def profile_names
    api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'])
    profile_names = api.get_profile_names
    latest_profile = api.get_latest_profile_for_program(APP_CONFIG['vsac']['default_program'])
    render :json => { profileNames: profile_names, latestProfile: latest_profile }
  end

  ##
  # GET /vsac_util/program_names
  #
  # Gets the list of program names from VSAC and returns in JSON the following object to contain the list:
  # { programNames: Array<String> }
  def program_names
    api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'])
    render :json => { programNames: api.get_program_names }
  end
  
  ##
  # GET /vsac_util/program_release_names/:program
  #
  # Gets the list of release names for a given program from VSAC and returns in JSON the following object to 
  # contain the list:
  # { programName: String, releaseNames: Array<String> }
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

  ##
  # GET /vsac_util/auth_valid
  #
  # Gets the status of the ticket_granting_ticket in the session. Returns JSON:
  # { valid: boolean, expires: DateTime }
  def auth_valid
    # If VSAC TGT is still valid, return its expiration date/time
    ticket_granting_ticket = session[:vsac_tgt]

    # If there is no VSAC ticket granting ticket then return false.
    if ticket_granting_ticket.nil? || ticket_granting_ticket.empty?
      session[:vsac_tgt] = nil
      render :json => {valid: false}

    # If it exists then check it using the API
    else
      begin
        Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], ticket_granting_ticket: ticket_granting_ticket)
        render :json => {valid: true, expires: ticket_granting_ticket[:expires]}

      # API will throw an error if it has expired
      rescue Util::VSAC::VSACTicketExpiredError
        session[:vsac_tgt] = nil
        render :json => {valid: false}
      end
    end
  end

  ##
  # POST /vsac_util/auth_expire
  #
  # Dumps the ticket_granting_ticket in the user session if there is one. Always returns JSON {}.
  def auth_expire
    # Force expire the VSAC session
    session[:vsac_tgt] = nil
    render :json => {}
  end
end
