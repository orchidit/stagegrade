class AccessCode < ActiveRecord::Base
  belongs_to :role

  def role_name=(new_role_name)
    r = Role.find_by_name(new_role_name)
    self[:role_id] = r.id unless r.nil?
  end

  def role_name
    role.nil? ? nil : role.name
  end

  def use
    self[:uses] += 1
    save!
  end
end
