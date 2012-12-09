module DateHelper
  def start_of_week(date = Date.today)
    (date - date.wday).to_datetime
  end

  def end_of_week(date = Date.today)
    (date + (6 - date.wday + 1)).to_datetime
  end

  def start_of_month(date = Date.today)
    DateTime.new(date.year, date.month, 1)
  end

  def end_of_month(date = Date.today)
    DateTime.new(date.year + date.month / 12, date.month % 12 + 1, 1)
  end
end