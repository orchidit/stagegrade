class UserReview < AbstractReview
  after_save :update_user_review_association_values
  after_destroy :update_user_review_association_values

  has_many :reports
  has_many :votes

  validate :conflict_specified
  validate :score_validation
  validate :disclosure_validation
  validate_on_create :one_review_per_user

  named_scope :from_friends_of, lambda { |user|
    if RAILS_ENV == "production"
      { :joins => :posted_by, :conditions => ["users.fb_user_id in (?)", user.fb_friend_ids] }
    else
      { :joins => :posted_by, :conditions => ["users.fb_user_id in (?)", user.fb_friend_ids.concat(["600343"])] }
    end
  }

  after_save :send_to_fb

  cattr_reader :per_page
  attr_accessor :production_url, :is_send_to_fb
  @@per_page = 100

  def dynamic_methods; /^(production)_([a-zA-Z_]\w*)(=?)/; end

  def initialize(attributes = nil)
    super(attributes)
    update_user_review_association_values
  end

  def conflict_specified
    errors.add_to_base("Disclosure choice must be specified") if has_conflict.nil?
  end

  def score_validation
    if score.nil?
      errors.add_to_base("Score can't be blank")
    elsif score > 14 or score < 0
      errors.add_to_base("Don't even think about trying to hack your score")
      logger.error("HACK ALERT: #{posted_by.name} tried to enter an invalid score of #{score}")
    end
  end

  def disclosure_validation
    if has_conflict? and (conflict_details.nil? or conflict_details.empty?)
      errors.add_to_base("Disclosure details can't be blank")
    end
  end

  def one_review_per_user
    if UserReview.count(:conditions => ["posted_by_id=? and production_id=?", self[:posted_by_id], self[:production_id]]) > 0
      errors.add_to_base "You have already posted a review for this production"
    end
  end

  def update_user_review_association_values
    update_association_values(:production, :all, :average_user_score, :median_user_score)
  end

  def vote_by_user(user_id)
    Vote.find_by_user_review_id_and_user_id(self.id, user_id)
  end

  def update_vote_counts
    cond = "user_review_id=? and up=?"
    self[:up_vote_count] = Vote.count(:conditions => [cond, self.id, true])
    self[:down_vote_count] = Vote.count(:conditions => [cond, self.id, false])
  end

  def send_to_fb
    user = User.find(self.posted_by_id)
    if user and user.fb_access_token and self.is_send_to_fb and self.production_url
      begin
        Koala::Facebook::API.new(user.fb_access_token).put_wall_post(
          "I reviewed #{self.production.play_title} on StageGrade.",
          :name => "#{Grading.grade_for_score(score)} - #{production.play_title}",
          :description => (text.length > 100 ? text[0...97] + "..." : text),
          :link => production_url
        )
      rescue Koala::Facebook::APIError => e
        logger.info "Koala raised an exception: #{e}"
        raise e unless e.fb_error_type == "OAuthException"
      end
    end
  end

  # class Date
  #   def before(other); self < other; end
  #   def after(other); self > other; end
  # end

  def self.get_90_day_moving_average(user_id = nil, step = 1)
    sql = ""
    if user_id.nil?
      sql = "select ur.id, date(ur.created_at) as `created_at_date`, count(*) as `count`" +
          "from user_reviews ur group by ur.posted_by_id, date(ur.created_at)"
    else
      sql = "select ur.id, date(ur.created_at) as `created_at_date`, count(*) as `count` " +
          "from user_reviews ur where ur.posted_by_id = #{user_id} group by ur.posted_by_id, date(ur.created_at)"
    end

    # Will return an array of hashes. { "created_at_date" => "date", "count" => "12", "id" => "3"}
    array = ActiveRecord::Base.connection.select_all(*sql)

    # Create the date range from start of year until today
    dates = Array.new
    Range.new(Date.parse("2010-01-01"), Date.today).step(step) { |i| dates << i }

    # For each of the dates, find the values from the query result that are within the 90 days prior to each date.
    # The result is an array for each of the dates of which we then sum the counts.
    values = Array.new

    values = dates.map do |d|
      array.select { |e| cd = Date.parse(e["created_at_date"]); cd < d+1 && cd > d - 91 }.reduce(0) { |sum, value| sum += value["count"].to_i } || 0
    end

    # Create an ordered hash of the dates/values and sort it by key (date).
    dates_values = ActiveSupport::OrderedHash[*dates.zip(values).flatten].sort { |e, f| e <=> f }
  end
end
