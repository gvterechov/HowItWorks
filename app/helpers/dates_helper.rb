module DatesHelper
  def full_date(date)
    date.strftime('%d.%m.%Y')
  end

  def full_datetime(datetime)
    datetime.strftime('%d.%m.%Y %H:%M')
  end

  def full_time(time)
    time.strftime("%H:%M:%S")
  end
end
