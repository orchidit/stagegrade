class Report < ActiveRecord::Base
  belongs_to :posted_by, :class_name => "User", :foreign_key => "posted_by_id"
  belongs_to :reviewed_by, :class_name => "User", :foreign_key => "reviewed_by_id"
  belongs_to :user_review

  validates_presence_of :text, :on => :create, :if => Proc.new { |r| !r.is_spam? }
end
