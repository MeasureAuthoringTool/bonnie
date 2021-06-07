module GroupHelper
  def self.sort_groups(groups)
    personal_group = nil
    shared_groups = []

    groups.each do |group|
      if group.is_personal
        personal_group = group
      else
        shared_groups << group
      end
    end

    return groups if shared_groups.length.zero?

    sorted_groups = shared_groups.sort_by(&:name)

    sorted_groups.unshift(personal_group) unless personal_group.nil?

    sorted_groups
  end
end
