class User < ActiveRecord::Base
  acts_as_authentic
  belongs_to :role
  has_many :reviews, :foreign_key => "posted_by_id"
  has_many :user_reviews, :foreign_key => "posted_by_id"
  has_many :reports, :foreign_key => "posted_by_id"
  has_many :votes
  has_many :posts

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :role_id, :on => :update
  validates_presence_of :username

  validates_uniqueness_of :email
  validates_uniqueness_of :username
  validates_uniqueness_of :fb_user_id, :allow_blank => true

  validates_format_of :username, :with => /\A\w[\w\.+\-_]+$/ # Only allow letters, numbers, dashes and underscores.

  validate :check_pre_save_errors

  after_save :check_access_code_usage

  cattr_reader :per_page
  @@per_page = 100

  def self.human_attribute_name(attribute_key_name)
    if attribute_key_name.to_sym == :fb_user_id
      "Facebook User ID"
    else
      super
    end
  end

  def self.new_from_fb_cookie_user(fb_access_token, fb_cookie_user_id)
    logger.info "token: #{fb_access_token}, fb_cookie_user_id: #{fb_cookie_user_id}"
    return nil if fb_access_token.nil? or fb_cookie_user_id.nil?

    user = User.new(:is_facebook_only => true)
    graph_user = user.fb_graph_user(fb_access_token)
    user.update_with_fb_me_hash(graph_user)
    user.fb_access_token = fb_access_token

    user.username = graph_user["username"]
    user.email = user.fb_email
    user.first_name = user.fb_first_name
    user.last_name = user.fb_last_name
    user.password = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{user.username}--")[0,6]
    user.password_confirmation = user.password

    user
  end

  def name
    [first_name, last_name].join(" ").strip
  end

  def name_with_title
    [self.name, self.title].reject(&:empty?).join(", ").strip
  end

  def role_id=(new_role_id)
    logger.info "In role_id=#{new_role_id}"
    if new_role_id.nil? or new_role_id.eql? ""
      self[:role_id] = Role.find_by_name("user").id
    else
      self[:role_id] = new_role_id
    end
  end

  def access_code=(new_code)
    @access_code = AccessCode.find_by_code(new_code)

    if !new_code.nil? and !new_code.empty? and @access_code.nil?
      pre_save_errors << "Access code is invalid"
      logger.info "Access code is invalid"
      logger.info pre_save_errors.to_s
    elsif !email.nil? and !@access_code.nil? and email.match(@access_code.email_expression).nil?
      pre_save_errors << "Access code is invalid for your email address"
    elsif @access_code.nil?
      logger.info "@access_code.nil? is true"
      self[:role_id] = (self[:role_id] || Role.find_by_name("user").id)
    else
      logger.info "else: #{@access_code.role_id}"
      self[:role_id] = @access_code.role_id
    end
  end

  def access_code
    nil
  end

  def pre_save_errors
    @pre_save_errors = Array.new if @pre_save_errors.nil?
    @pre_save_errors
  end

  def check_pre_save_errors
    pre_save_errors.each { |error| errors.add_to_base error }
    @pre_save_errors = nil
  end

  def check_access_code_usage
    @access_code.use if !@access_code.nil?
  end

  def self.find_by_username_or_email(login)
    User.find_by_username(login) || User.find_by_email(login)
  end

  def admin?
    !role.nil? and role.name.downcase.eql? "admin"
  end

  def super_user?
    !role.nil? and role.name.downcase.eql? "super_user"
  end

  def has_reviewed?(production_id)
    user_reviews.map(&:production_id).include?(production_id)
  end

  def has_reported?(user_review_id)
    reports.map(&:user_review_id).include?(user_review_id)
  end

  def has_voted?(user_review_id)
    votes.map(&:user_review_id).include?(user_review_id)
  end

  def tdf_eligible?
    # admin? || UserReview.get_90_day_moving_average(self.id).any? { |date_value| date_value.last >= 7 }
    false
  end

  def link_to_fb_cookie_user(fb_cookie_user_id)
    return if fb_cookie_user_id.nil?

    update_with_fb_me_hash(fb_graph_user)
    save
  end

  def fb_graph_user(fb_access_token = nil)
    fb_access_token ||= self.fb_access_token

    begin
      Koala::Facebook::API.new(fb_access_token).get_object("me")
    rescue Koala::Facebook::APIError => e
      raise e unless e.fb_error_type == "OAuthException"
    end
  end

  def fb_friends(fb_access_token = nil)
    fb_access_token ||= self.fb_access_token

    begin
      Koala::Facebook::API.new(fb_access_token).get_connections("me", "friends")
    rescue Koala::Facebook::APIError => e
      raise e unless e.fb_error_type == "OAuthException"
    end
  end

  def fb_friend_ids(fb_access_token = nil)
    (fb_friends(fb_access_token) || []).map { |f| f["id"] }
  end

  def update_with_fb_me_hash(hash)
    return if hash.nil?
    hash = HashWithIndifferentAccess.new(hash)
    self.fb_user_id = hash[:id]
    self.fb_first_name = hash[:first_name]
    self.fb_last_name = hash[:last_name]
    self.fb_email = hash[:email]
  end

  def fb_unlink
    self.fb_access_token = nil
    self.fb_user_id = nil
    self.fb_first_name = nil
    self.fb_last_name = nil
    self.fb_email = nil
  end
end
