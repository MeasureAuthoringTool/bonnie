module CQM
  class Patient
    belongs_to :user
    scope :by_user, ->(user) { where({'user_id'=>user.id}) }
  end
end
