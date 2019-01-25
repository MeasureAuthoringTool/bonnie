module CQM
  class MeasurePackage
    belongs_to :user
    scope :by_user, ->(user) { where user_id: user.id }
    index 'user_id' => 1
  end
end