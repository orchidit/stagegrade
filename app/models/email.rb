class Email < ActiveRecord::Base
  validates_presence_of :address, :message => "can't be blank."
  validates_uniqueness_of :address, :if => Proc.new { |email| email.is_active_was == true },
      :message => "is already subscribed."

  validate :does_not_have_account
  named_scope :active, :conditions => [ "is_active=?", true ]
  named_scope :inactive, :conditions => [ "is_active=?", false ]

  cattr_reader :per_page
  @@per_page = 100

  def does_not_have_account
    if User.find_by_email(self.address)
      errors.add(:base, :has_account, :message => "You already have an account. Make sure you have the option to receive emails from us enabled.")
    end
  end

  def get_redirect_values
    ret_val = { :redirect => nil, :redirect_back => nil }
    if self.errors.count > 0
      redirect_for_types = {
        :has_account => [ :edit_account_url, false ],
        :default => [ :root_url, true ]
      }
      if self.errors.for(:base) and self.errors.for(:base).map(&:type).include?(:has_account)
        ret_val[:redirect], ret_val[:redirect_back] = redirect_for_types[:has_account]
      else
        ret_val[:redirect], ret_val[:redirect_back] = redirect_for_types[:default]
      end
    end
    ret_val
  end
end
