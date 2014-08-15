class UsersController < ApplicationController

  protect_from_forgery
  before_filter :authenticate_user!

  respond_to :json

  def bundle
    exporter = Measures::Exporter::BundleExporter.new(current_user, version: '1.0', hqmfjs_libraries_version: APP_CONFIG['hqmfjs_libraries_version'], effective_date: ( Time.at(APP_CONFIG['measure_period_start']).utc + 1.year - 1.minute ).to_i)
    zip_data = exporter.export_zip

    cookies[:fileDownload] = "true" # We need to set this cookie for jquery.fileDownload

    send_data zip_data, :type => 'application/zip', :disposition => 'attachment', :filename => "bundle_#{current_user.email}_export.zip"
  end

end
