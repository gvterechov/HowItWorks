module IconsHelper
  def ok_icon
    '<i class="check green icon"></i>'.html_safe
  end

  def error_icon
    '<i class="x red icon"></i>'.html_safe
  end

  def book_icon(sign)
    sign ? ok_icon : error_icon
  end
end
