module CQM
  class MeasurePackage
    belongs_to :group
    scope :by_user, ->(user) { where group_id: user.current_group.id }
    index 'group_id' => 1
  end
end
