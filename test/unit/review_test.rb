require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  def test_nil_production_play_title_for_nil_production
    r = Review.new
    assert_nil r.production
    assert_nothing_raised NoMethodError do
      assert_nil r.production_play_title
    end
  end

  def test_reviews_sorted_desc_by_grade
    c = Critic.new(:name => "a"); c.save
    p = Publication.new(:name => "a"); p.save

    r1 = Review.new(:production_play_title => "a", :score => 1.0, :critic => c, :publication => p)
    r2 = Review.new(:production_play_title => "a", :score => 2.0, :critic => c, :publication => p)
    r1.save! ; r2.save!

    reviews1 = Review.find :all, :order => "score DESC"
    reviews2 = Review.ranked_by_grade(:desc)
  end

  def test_validations
    prod = Production.new(:play_title =>"a")
    prod.save!

    c = Critic.new(:name => "a")
    c.save!

    pub = Publication.new(:name => "a")
    pub.save!

    r1 = Review.new
    assert_invalid r1, "Valid without production and raw score"
    
    r1.production = prod
    assert_invalid r1, "Valid without raw score"
    
    r1.production = nil
    r1.score = 5.0
    assert_invalid r1, "Valid without production"
    
    r1.score = "a"
    assert_invalid r1, "Valid with single char score"
    
    r1.score = "asd"
    assert_invalid r1, "Valid with multi char score"
    
    r1.production = prod
    r1.score = 5.0
    r1.critic = c
    r1.publication = pub
    assert r1.valid?, "Invalid when should be valid"
  end

  def test_update_production_average
    c = Critic.new(:name => "a"); c.save!
    pub = Publication.new(:name => "a"); pub.save!
    puts "Create production and save"
    p = Production.new(:play_title => "a"); p.save!

    puts "Create review and save"
    r = Review.new(:production => p, :critic => c, :publication => pub, :score => 10)
    r.save!
    puts r.inspect

    assert_equal p.average_score, nil # production is unpublished
    
    puts "Set published_site = true"
    p.is_published_site = true
    p.save!
    assert_equal p.average_score, 10.0

    puts "Add second review"
    r = Review.new(:production => p, :score => 20)
    r.save!

    assert_equal p.average_score, 15
  end
end
