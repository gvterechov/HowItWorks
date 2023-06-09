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

  def sign_out_icon
    '<i class="sign-out icon"></i>'.html_safe
  end

  def sign_in_icon
    '<i class="sign-in icon"></i>'.html_safe
  end

  def sync_icon
    '<i class="sync icon"></i>'.html_safe
  end

  def close_icon(klass = '')
    "<i class='#{klass} close icon'></i>".html_safe
  end
end
