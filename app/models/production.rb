class Production < ActiveRecord::Base
  include ActionView::Helpers::TextHelper

  belongs_to :play
  belongs_to :theatre
  belongs_to :posted_by, :class_name => "User", :foreign_key => "posted_by_id"
  has_many :reviews
  has_many :user_reviews
  has_many :relationships, :include => :relationship_type, :order => "relationship_types.name"
  has_many :participants, :through => :relationships

  def friend_reviews(user)
    UserReview.for_production(self).from_friends_of(user).all
  end

  has_attached_file :photo, :default_url => "/missing.jpg", :styles => { :n => "270x1000>", :t => "44x44#" },
      :default_style => :n
  has_attached_file :ad

  validates_presence_of :play_id
  validate :previews_before_opens
  validate :opens_before_closes
  validate :all_reviews_are_graded, :if => Proc.new { |p| p.is_published_site }
  validates_numericality_of :min_ticket_price, :allow_nil => true, :greater_than_or_equal_to => 0
  validates_numericality_of :max_ticket_price, :allow_nil => true, :greater_than_or_equal_to => 0

  accepts_nested_attributes_for :relationships, :allow_destroy => true

  named_scope :site_published, :conditions => { :is_published_site => true }
  named_scope :feed_published, :conditions => { :is_published_feed => true }
  named_scope :playing, :conditions => ["(is_playing_override = ? " +
      "or ((preview_date is null and preview_date <= curdate()) " +
        "or (opening_date is null or opening_date <= curdate())) " +
      "and (closing_date is null or closing_date >= curdate())) " +
      "and (opening_date is not null or closing_date is not null)", "Open"]
  named_scope :will_open, :conditions => ["opening_date > curdate()"]

  named_scope :sort_by_critic, :order => "median_score desc, average_score desc, play_sort_title"
  named_scope :sort_by_community, :order => "IF((select count(*) from user_reviews where production_id=productions.id) > 4, median_user_score, 0) desc, median_score desc, average_score desc, play_sort_title"
  named_scope :sort_by_opening, :order => "IF(ISNULL(opening_date),1,0), opening_date desc, median_score desc"
  named_scope :sort_by_closing, :order => "IF(ISNULL(closing_date),1,0), closing_date, median_score desc"
  named_scope :sort_by_title, :order => "play_sort_title"

  cattr_reader :per_page
  @@per_page = 100

  def self.find_with_params(params = nil, order = nil)
    extend DateHelper
    # If the finder has a where clause, and params.has_key?, then add where clause to where array and
    # add params value to where_params. If the finder does not have a where clause, but the finder itself
    # has the key, add the value to the where array.
    finders = {
      :show_type => { :where => "is_musical = ?", :params => { :musical => true, :play => false } },
      :on_broadway => { :where => "is_on_broadway = ?", :params => { :true => true, :false => false } },
      :ticket_price => { :where => "min_ticket_price < ? or max_ticket_price < ?", :params => {
          :under_20 => [20,20], :under_50 => [50,50], :under_100 => [100,100], :under_150 => [150,150] } },
      :special_features => { :families => "is_for_families = true", :stars => "has_stars = true" },
      :dates => { :closing_week => "is_playing_override != \"Open\" " +
        "and closing_date >= '" + start_of_week.to_formatted_s + "' " +
        "and closing_date <= '" + end_of_week.to_formatted_s + "'",
        :closing_month => "is_playing_override != \"Open\" " +
          "and closing_date >= '" + start_of_month.to_formatted_s + "' " +
          "and closing_date <= '" + end_of_month.to_formatted_s + "'",
        :opening_month =>
            "(preview_date >= '" + (1.month.ago - 1.day).end_of_day.to_formatted_s + "' " +
            "and preview_date <= '" + Date.today.end_of_day.to_formatted_s + "') or " +
            "(opening_date >= '" + (1.month.ago - 1.day).end_of_day.to_formatted_s + "' " +
            "and opening_date <= '" + Date.today.end_of_day.to_formatted_s + "')" },
      :archives => {
          :hide => "is_playing_override = \"Open\" " +
          "or ((preview_date is not null and preview_date <= curdate()) " +
              "or (opening_date is null or opening_date <= curdate())) " +
          "and (closing_date is null or closing_date >= curdate()) " +
          "and (opening_date is not null or closing_date is not null)"
      }
    }

    # First, create Hashes so that we can properly override defaults and make sure we don't have duplicate keys.
    # Then, create arrays so that we know the params and the bind variables are properly ordered.
    wheres = { :archives => finders[:archives][:hide] }
    where_params = { }

    # Checking for shows opening in the future should not filter out closed shows.
    if params[:dates] == "opening_month" or params[:archives] != nil
      wheres.delete(:archives)
    end

    params.each do |key, value|
      k = key.to_sym
      v = value.to_sym
      if (finders.has_key? k and finders[k].has_key? :where and
          finders[k].has_key? :params and finders[k][:params].has_key? v)
        wheres[k] = finders[k][:where]
        where_params[k] = finders[k][:params][v]
      elsif finders.has_key? k and finders[k].has_key? v
        wheres[k] = finders[k][v]
      end
    end

    # Create the conditions and condition_params arrays so that the conditions line up
    # with the proper bind variables.
    conditions = []
    condition_params = []

    wheres.each do |k, v|
      conditions.push(v)
      condition_params.push(where_params[k])
    end

    # Determine the sort order
    order = "sort_by_" + (params[:sort].nil? ? "critic" : params[:sort])

    self.site_published.send(order.to_sym).all(:include => [:user_reviews, :reviews], :conditions =>
        [conditions.map { |w| "(#{w})"}.join(" AND "), condition_params.reject{ |c| c.nil? }].flatten)
  end

  def self.find_or_create_by_description(desc)
    m = desc.match(/\(([0-9]+)\)/)
    if !m.nil?
      find(m[1])
    else
      find_or_create_by_play_title(desc.split(" (")[0])
    end
  end

  # Method for post "protocol" conformance.
  def published_at; feed_published_at; end
  def original_published_at; original_feed_published_at; end

  def description
    "#{play_title} (#{id})"
  end

  def description_before_type_cast
    description
  end

  def status
    return "Full" if is_published_feed
    return "Site" if is_published_site
    return "Draft"
  end

  def calculated_median_score
    Grading.median(self.reviews.map { |r| r.score }.sort)
  end

  def calculated_median_grade
    Grading.grade_for_score(self.calculated_median_score)
  end

  def site_published_at
    if self.is_published_site and self.is_site_published_at_override and !self.site_published_at_override.nil?
      self.site_published_at_override
    else
      self[:site_published_at]
    end
  end

  def original_feed_published_at
    self[:feed_published_at]
  end

  def feed_published_at
    if self.is_published_feed and self.is_feed_published_at_override and !self.feed_published_at_override.nil?
      self.feed_published_at_override
    else
      self[:feed_published_at]
    end
  end

  def is_published_site=(publish)
    if self.is_published_site_before_type_cast != publish
      self[:is_published_site] = publish
      if self[:is_published_site]
        self[:site_published_at] ||= Time.now
      else
        self[:site_published_at] = nil
      end
    end
    reviews.each { |r| r.is_published_site = publish; r.save(false) }
  end

  def is_published_feed=(publish)
    if self.is_published_feed_before_type_cast != publish
      self[:is_published_feed] = publish
      if self[:is_published_feed]
        self[:feed_published_at] ||= Time.now
      else
        self[:feed_published_at] = nil
      end
    end
    reviews.each { |r| r.is_published_feed = publish; r.save(false) }
  end

  def play_title=(new_play)
    return if self.play_title == new_play

    p = Play.find_or_create_by_title(new_play)
    p.save if p.new_record?
    self[:play_id] = p.id
    self[:play_title] = p.title
    self[:play_sort_title] = p.sort_title
  end

  def theatre_name
    theatre.nil? ? nil : theatre.name
  end

  def theatre_name=(new_theatre)
    t = Theatre.find_or_create_by_name(new_theatre)
    t.save
    self[:theatre_id] = t.id
  end

  def grouped_relationships
    grouped = {}
    rels = []
    rels.concat(play.relationships) unless play.nil?
    rels.concat(relationships)

    rels.each do |r|
      grouped[r.connector] ||= Array.new
      grouped[r.connector] << r
    end
    grouped
  end

  def previews_before_opens
    if !self.preview_date.nil? and !self.opening_date.nil? and self.preview_date > self.opening_date
      errors.add_to_base("Preview date must be before opening date")
    end
  end

  def opens_before_closes
    if !self.opening_date.nil? and !self.closing_date.nil? and self.opening_date > self.closing_date
      errors.add_to_base("Opening date must be before closing date")
    end
  end

  def all_reviews_are_graded
    nil_scores = self.reviews.select { |r| r.score.nil? }.count
    errors.add_to_base("All reviews must be graded before publishing (#{nil_scores} ungraded)") if nil_scores > 0
  end

  def will_preview(t = Date.today)
    !preview_date.nil? and (preview_date <=> t) >= 0
  end

  def will_open(t = Date.today)
    !opening_date.nil? and (opening_date <=> t) >= 0
  end

  def will_close(t = Date.today)
    !closing_date.nil? and (closing_date <=> t) >= 0
  end

  def has_previewed(t = Date.today)
    !preview_date.nil? and (preview_date <=> t) < 0
  end

  def has_opened(t = Date.today)
    !opening_date.nil? and (opening_date <=> t) < 0
  end

  def has_closed(t = Date.today)
    !closing_date.nil? and (closing_date <=> t) < 0
  end

  def is_playing(t = Date.today)
    return is_playing_override == "Open" if !is_playing_override.nil? and !is_playing_override.empty?
    return false if preview_date.nil? and opening_date.nil? and closing_date.nil?
    ((has_previewed or has_opened) and (closing_date.nil? or will_close)) or (opening_date.nil? and will_close)
  end

  def preview_date_text
    return preview_date.strftime "Previews Begin %x" if will_preview
    return preview_date.strftime "Previews Began %x" if has_previewed
    return nil
  end

  def opening_date_text
    if self.opening_date.nil?
      if !self.closing_date.nil? or self.is_playing_override == "Open"
        return "Opened"
      else
        return "Unknown Opening Date"
      end
    end

    diff = self.opening_date <=> Date.today # + if in the future, - if in the past

    if diff >= 0
      opening_date.strftime "Opens %x"
    else
      opening_date.strftime "Opened %x"
    end
  end

  def closing_date_text
    if self.is_playing_override == "Open" or (!self.opening_date.nil? and self.closing_date.nil?)
      return "Open Run"
    elsif self.closing_date.nil? or self.is_playing_override == "Closed"
      return "Closed"
    end

    diff = self.closing_date <=> Date.today # + if in the future, - if in the past
    if diff >= 0
      closing_date.strftime "Closes %x"
    else
      closing_date.strftime "Closed %x"
    end
  end

  def date_text
    [self.preview_date_text, self.opening_date_text, self.closing_date_text].reject(&:nil?).join("<br />")
  end

  def next_date_text
    if will_preview
      return preview_date_text
    elsif will_open
      return opening_date_text
    else
      return closing_date_text
    end
  end

  def grade_buy_buttons(offset = -11)
    Rails.cache.fetch("grade_buy-#{self.id}-#{offset}") do
      ActionView::Base.new(Rails::Configuration.new.view_path).render(:partial => "productions/grade_buy_buttons",
        :locals => { :production => self, :offset => offset })
    end
  end

  def broadway_hotel_url
    "http://boxoffice.broadway.com/boxoffice/lob.aspx?lob=2&aff=68&id=" + broadway_com_id
  end

  def broadway_ticket_url
    "http://boxoffice.broadway.com/boxoffice/lob.aspx?lob=1&aff=68&id=" + broadway_com_id
  end

  def running_time_display(include_text_field = false)
    return nil if running_time.nil? or running_time <= 0

    comps = []
    hours = (running_time / 60).floor
    mins = running_time % 60

    comps << pluralize(hours, "hour") if hours != 0
    comps << pluralize(mins, "minute") if mins != 0
    comps.join(" ") + (running_time_text.empty? ? "" : " (#{running_time_text})")
  end

  def on_or_beyond
    is_on_broadway ? "on" : "beyond"
  end

  def badges
    items = { :is_musical => { :true => "Musical", :false => "Play" },
      :is_on_broadway => { :true => "On Broadway", :false => "Beyond Broadway" },
      :is_for_families => { :true => "Great for Families" },
      :has_stars => { :true => "Stars on Stage" }
    }
    ordered = [ :is_musical, :is_on_broadway, :is_for_families, :has_stars ]
    badges = []
    ordered.each do |key|
      badge = items[key][send(key).to_s.to_sym]
      badges << [key, badge] if !badge.nil?
    end
    badges.map(&:last)
  end

  def boolean_description
    # TODO: Re-add these booleans once we've decided how to handle them (MG 3/10/10)
    # items = [
    #       { :is_for_adults => is_for_adults },
    #       { :is_for_families => is_for_families },
    #       { :is_for_kids => is_for_kids }
    #     ]
    items = []

    descriptions = []
    descriptions = items.map { |hash|
      key, val = hash.keys[0], hash.values[0]
      str = key.to_s.split("_")[1..-1].join(" ").titleize
      str if val == true
    }

    descriptions << (on_or_beyond + " Broadway").titleize
    descriptions << "Musical" if is_musical

    descriptions.select { |i| i }.join("<br />")
  end

  def average_grade
    Grading.grade_for_score(self.average_score)
  end

  def median_grade
    Grading.grade_for_score(self.median_score)
  end

  def average_user_grade
    Grading.grade_for_score(self.average_user_score)
  end

  def median_user_grade(count = nil)
    score = (count || self.user_reviews.count) > 4 ? self.median_user_score : nil
    Grading.grade_for_score(score)
  end

  def median_friends_grade(user)
    Grading.grade_for_score(Grading.median(friend_reviews(user).map(&:score)))
  end

  def latest_reviews
    self.reviews.sort { |r, s| s.created_at <=> r.created_at }
  end

  def method_missing(method_id, *arguments)
    if match = /^auto_complete_for_play_theatre_([a-zA-Z]\w*)/.match(method_id.to_s)
      auto_completer(match[1], match[2])
    else
      super
    end
  end

  def auto_completer(association, method)
    param_value = params[:review].send("[]", (association + "_" + method).to_sym)
    re = Regexp.new("^#{param_value}", "i")
    find_options = { :order => method + " ASC" }
    @all_objs = Kernel.const_get(association.singularize.capitalize).send(:all, find_options)
    @collection = @all_objs.collect(&(method.to_sym)).select { |obj| obj.match re }
    render :inline => "<%= content_tag(:ul, @collection.map { |obj| content_tag(:li, h(obj)) }) %>"
  end
end
