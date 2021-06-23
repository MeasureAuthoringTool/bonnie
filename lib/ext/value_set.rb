module CQM
  class ValueSet
    belongs_to :group
    scope :by_user, ->(user) { where group_id: user.current_group.id }
    index 'group_id' => 1
  end
end
