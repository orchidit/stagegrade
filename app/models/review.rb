class Review < AbstractReview
  after_save :update_review_association_values
  after_destroy :update_review_association_values

  belongs_to :critic
  belongs_to :publication

  validates_presence_of :critic_id, :publication_id
  validates_presence_of :score, :on => :create, :message => "can't be blank",
      :if => Proc.new { |review| review.is_published_site }
  validates_format_of :link_url, :with => URI::regexp(%w(http https)), :allow_nil => true, :allow_blank => true
  validates_numericality_of :score, :allow_nil => true

  named_scope :published, :joins => :production, :conditions => { "is_published_site" => true }
  named_scope :playing, :joins => :production, :conditions => ["(is_playing_override = ? " +
      "or (opening_date is null or opening_date <= curdate()) " +
      "and (closing_date is null or closing_date >= curdate())) " +
      "and (opening_date is not null or closing_date is not null)", "Open"]

  def dynamic_methods; /^(production|critic|publication)_([a-zA-Z_]\w*)(=?)/; end

  def initialize(attributes = nil)
    super(attributes)

    if !production.nil?
      self.is_published_site = production.is_published_site
      self.is_published_feed = production.is_published_feed
    end
    update_review_association_values
  end
  
  def update_review_association_values
    update_association_values([:production, :critic, :publication], :published, :average_score, :median_score)
  end

  def production=(new_prod)
    self[:production] = new_prod
    is_published_site = new_prod.is_published_site
    is_published_feed = new_prod.is_published_feed
  end

  def production_id=(new_prod_id)
    self[:production_id] = new_prod_id
    is_published_site = Production.find(new_prod_id).is_published_site
    is_published_feed = Production.find(new_prod_id).is_published_feed
  end

  def production_play_title=(new_play)
    p = Production.find_or_create_by_play_title(new_play)
    p.save if p.new_record?
    self.production_id = p.id
  end
end