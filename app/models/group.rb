class Group
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  index({ name: 1 },
        { unique: true, name: "group_name_index" })

  has_many :cqm_measures, class_name: 'CQM::Measure'
  has_many :patients, class_name: 'CQM::Patient'

  field :name, :type => String
  field :is_personal, :type => Boolean, :default => false

  def find_users
    User.in(group_ids: id)
  end
end
