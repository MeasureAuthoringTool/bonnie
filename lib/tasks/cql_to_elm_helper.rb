require_relative './cql_to_elm_helper'
class CqlToElmHelper
  # Translates the cql to elm json using a post request to CQLTranslation Jar.
  # Returns an array of JSON ELM and an Array of XML ELM
  def self.translate_cql_to_elm(cql)
    request = RestClient::Request.new(
      :method => :post,
      :accept => :json,
      :content_type => :json,
      :url => 'http://localhost:8080/cql/translator',
      :payload => {
        :multipart => true,
        :file => cql
      }
    )

    elm_json = request.execute

    # now get the XML ELM
    request = RestClient::Request.new(
      :method => :post,
      :headers => {
        :accept => 'multipart/form-data',
        'X-TargetFormat' => 'application/elm+xml'
      },
      :content_type => 'multipart/form-data',
      :url => 'http://localhost:8080/cql/translator',
      :payload => {
        :multipart => true,
        :file => cql
      }
    )
    elm_xmls = request.execute

    return parse_elm_response(elm_json), parse_multipart_response(elm_xmls)
  rescue RestClient::BadRequest => e
    begin
      # If there is a response, include it in the error else just include the error message
      cql_error = JSON.parse(e.response)
      error_msg = JSON.pretty_generate(cql_error).to_s
    rescue StandardError
      error_msg = e.message
    end
    # The error text will be written to a load_error file and will not be displayed in the error dialog displayed to the user since
    # measures_controller.rb does not handle this type of exception
    raise MeasureLoadingException.new "Error Translating CQL to ELM: " + error_msg
  end

  # Parse the JSON response into an array of json objects (one for each library)
  def self.parse_elm_response(response)
    parts = pre_process_response(response)
    # Grabs everything from the first '{' to the last '}'
    results = parts.map { |part| part.match(/{.+}/m).to_s }
    results
  end

  def self.parse_multipart_response(response)
    parts = pre_process_response(response)
    parsed_parts = []
    parts.each do |part|
      lines = part.split("\r\n")
      # The first line will always be empty string
      lines.shift

      # find the end of the http headers
      header_end_index = lines.find_index { |line| line == '' }

      # Remove the headers and reassemble
      lines.shift(header_end_index+1)
      parsed_parts << lines.join("\r\n")
    end
    parsed_parts
  end

  def self.pre_process_response(response)
    # Not the same delimiter in the response as we specify ourselves in the request,
    # so we have to extract it.
    delimiter = response.split("\r\n")[0].strip
    parts = response.split(delimiter)
    # The first part will always be an empty string. Just remove it.
    parts.shift
    # The last part will be the "--". Just remove it.
    parts.pop
    parts
  end
end