class Group
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  has_many :cqm_measures, class_name: 'CQM::Measure'
  has_many :patients, class_name: 'CQM::Patient'

  field :name, :type => String
  field :is_private, :type => Boolean, :default => false

  def get_users
    User.in(group_ids: self.id)
  end

end