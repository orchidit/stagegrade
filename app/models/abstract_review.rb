class AbstractReview < ActiveRecord::Base
  self.abstract_class = true
  belongs_to :production
  belongs_to :posted_by, :class_name => "User", :foreign_key => "posted_by_id"

  validates_presence_of :production_id

  named_scope :for_production, lambda { |prod| { :conditions => ["production_id=?", prod.id] }}
  named_scope :score_desc, :order => "score desc"

  cattr_reader :per_page
  @@per_page = 100

  def dynamic_methods; /^$/; end

  def update_association_values(associations, scope, average_method, median_method)
    assocs = nil

    if associations.is_a? Array
      assocs = associations
    elsif associations.is_a? Symbol
      assocs = [associations]
    elsif associations.is_a? String
      assocs = [associations.to_sym]
    end

    assocs.each do |assoc|
      a = send(assoc)
      unless a.nil?
        conditions = [assoc.to_s + "_id=?", a.id]
        scores = []

        if scope.eql? :all
          a.send("#{average_method}=", self.class.average(:score, :conditions => conditions))
          scores = self.class.all(:conditions => conditions, :order => "score").map(&:score)
        else
          a.send("#{average_method}=", self.class.send(scope).average(:score, :conditions => conditions))
          scores = self.class.send(scope).all(:conditions => conditions, :order => "score").map(&:score)
        end
        a.send("#{median_method}=", Grading.median(scores))

        updated_at_field = "#{self.class.to_s.underscore}_updated_at="
        if !production.nil? and production.is_published_site and a.respond_to?(updated_at_field)
          a.send(updated_at_field, updated_at)
        end
        a.save(false)
      end
    end
  end

  def grade
    Grading.grade_for_score(self.score)
  end

  def self.ranked_by_grade(order)
    published(:order => "score #{order.to_s}")
  end

  def self.latest_reviews
    published(:order => "created_at DESC")
  end

  def self.average_grade
    Grading.grade_for_score(published.average(:score))
  end

  def self.median_grade
    Grading.grade_for_score(Grading.median(published(:select => "score").map(&:score)))
  end

  def production_play_title=(new_play)
    p = Production.find_or_create_by_play_title(new_play)
    p.save if p.new_record?
    self.production_id = p.id
  end
end

## Enhanced Assocations
class AbstractReview
  def respond_to?(method)
      if dynamic_methods.match(method.to_s)
        return true
      else
        super
      end
    end

  def method_missing(method_id, *arguments, &block)
      if match = dynamic_methods.match(method_id.to_s)
        assoc = match[1]
        method = match[2]
        if match[3] == "="
          set(match[1], match[2], *arguments)
        else
          get(match[1], match[2])
        end
      else
        super
      end
    end

  def set(association_name, method_name, value)
      assoc_obj = association_name.singularize.capitalize.constantize.send("find_or_create_by_#{method_name}", value)
      assoc_obj.save if assoc_obj.new_record?
      self[(association_name + "_id").to_sym] = assoc_obj.id
      send(association_name).send(:save) unless send(association_name).nil?
    end

  def get(association_name, method_name)
      if send(association_name).nil?
        nil
      else
        send(association_name.to_sym).send(method_name)
      end
    end
end
