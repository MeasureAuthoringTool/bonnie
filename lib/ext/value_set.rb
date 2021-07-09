module CQM
  class ValueSet
    belongs_to :user
    scope :by_user, ->(user) { where user_id: user.id }
    index 'user_id' => 1
  end
end
