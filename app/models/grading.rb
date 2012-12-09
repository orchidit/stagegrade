class Grading
  @@grades_array = nil
  @@descriptors = nil
  @@colors = nil
  cattr_reader :grades_array
  attr_accessor :score, :grade, :descriptor, :color

  def self.all
    array = @@grades_array || get_grades_array
    ret = []
    array.each_index do |i|
      g = Grading.new
      g.score = i
      g.grade = array[i]
      g.descriptor = self.descriptors[i]
      g.color = self.colors[i]
      ret << g
    end
    ret.reverse
  end

  def self.grade_for_score(score)
    get_grades_array if @@grades_array.nil?
    score.nil? ? "NA" : @@grades_array[score.round]
  end

  def self.color_for_score(score)
    score.nil? ? "#ddd" : colors[score.round]
  end

  def self.get_grades_array
    @@grades_array = Array.new
    %w{ F D C B A }.each do |letter|
      ["-", "", "+"].each do |mod|
        @@grades_array << "#{letter}#{mod}"
      end
    end
    @@grades_array
  end

  def self.descriptors
    @@descriptors unless @@descriptors.nil?
    @@descriptors = [ "crazy hatred", "total hatred", "near-total hatred",
      "really dislike", "solidly dislike", "mildly dislike",
      "leaning negative", "on the fence", "leaning positive",
      "mildly like", "solidly like", "really like",
      "near-total love", "total love", "crazy love" ]
  end

  def self.colors
    @@colors unless @@colors.nil?
    @@colors = [ "#E80000", "#E80000", "#E80000",
      "#FF9500", "#FF9500", "#FF9500",
      "#FFD557", "#FFFF75", "#FFFF75",
      "#00FF00", "#00FF00", "#00FF00",
      "#1BB500", "#1BB500", "#1BB500" ]
  end

  def self.median(scores)
    return nil if scores.nil? or scores.empty? or scores.select { |s| s.nil? }.count > 0

    n = (scores.length - 1) / 2
    n2 = scores.length / 2

    if scores.length.even?
      (scores[n] + scores[n2]) / 2
    else
      scores[n]
    end
  end

  def self.grouped_grades_for_scores(scores)
    grouped = { "A" => 0, "B" => 0, "C" => 0, "D" => 0, "F" => 0}
    scores.each do |s|
      gfs = self.grade_for_score(s)[0,1]
      grouped[gfs] += 1 if grouped.has_key? gfs
    end
    grouped
  end
end