class RegistrationsController < Devise::RegistrationsController


  # updated from original to look for changes to crosswalking changes
  def update_resource(resource, params)
    crosswalk_enabled = resource.crosswalk_enabled
    saved = super(resource, params)
    if saved && resource.is_portfolio? && (resource.crosswalk_enabled != crosswalk_enabled)
      Measure.by_user(current_user).each do |m|
        m.map_fns.clear
        m.save
     end
    end
    return saved
  end

end