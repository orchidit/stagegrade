class Relationship < ActiveRecord::Base
  belongs_to :relationship_type
  belongs_to :participant
  belongs_to :play
  belongs_to :production

  cattr_reader :per_page
  @@per_page = 100

  def connector
    return custom_connector unless custom_connector.nil? or custom_connector.empty?
    relationship_type.default_connector
  end

  def play_title
    play.nil? ? production.play_title : play.title
  end

  def play_title=(new_play)
    p = Play.find_or_create_by_title(new_play)
    p.save
    self[:play_id] = p.id
  end

  def participant_name=(new_part)
    p = Participant.find_or_create_by_name(new_part)
    p.save
    self[:participant_id] = p.id
  end

  def participant_name
    participant.nil? ? "" : participant.name
  end

  def play_or_production
    return "Play" if play
    return "Production" if production
    return ""
  end
end
