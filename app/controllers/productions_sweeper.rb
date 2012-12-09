class ProductionsSweeper < ActionController::Caching::Sweeper
  observe Production

  def before_save(prod)
    if prod.changes.has_key? :broadway_com_id or prod.changes.has_key? :ticket_url
      Rails.cache.find("grade_buy-#{prod.id}-*").each do |hit|
        Rails.cache.delete(hit.split("/").last)
      end
    end
  end
end