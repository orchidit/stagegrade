class PanelsSweeper < ActionController::Caching::Sweeper
  observe Production, Play, Panel

  def after_save(record)
    if record.is_a? Panel
      expire_fragment("panel-#{record.id}")
      return
    end

    Panel.all.each do |panel|
      items = eval(panel.items)
      map_attr = :id
      record_attr = :id
      if record.is_a? Play
        map_attr = :play_title
        record_attr = :title
      end

      if items.length > 0 and items.map(&map_attr).include?(record.send(record_attr))
        expire_fragment("panel-#{panel.id}")
      end
    end
  end
end