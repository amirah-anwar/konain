module ApplicationHelper

  def flash_class(name)
    {
      "notice"  => "alert alert-info",
      "success" => "alert alert-success",
      "error"   => "alert alert-danger",
      "alert"   => "alert alert-danger",
    }[name]
  end

  def active_tab(controller, action)
    'current_page_item' if params[:controller] == controller && params[:action] == action
  end

  def is_active(index)
    'active' if index.zero?
  end

  def banner_image_url(name)
    Banner.fetch_url(name)
  end

  def backgroung_image_url(name)
    url = banner_image_url(name)
    banner_path = if check_backgroung_image_url?(url)
      asset_path(url)
    else
      url
    end
      ["background-image: url(", banner_path, ")"].join("")
  end

  def titleize(value)
    value.to_s.titleize
  end

  def check_backgroung_image_url?(url)
    url == Banner::DEFAULT_BANNER_URL || url == Banner::DEFAULT_HOME_BANNER_URL
  end

  def favourite_class(property)
    return "favourite-listing" if user_signed_in? && !is_owner?(property)
  end

  def pre_login_listing
    return "pre-login-listing" unless user_signed_in?
  end

  def check_page_banner?(banner, url)
    banner_image_url(banner) == url
  end

  def alert_holder(params)
    return 'alertHolder' if user_signed_in? || params[:controller].in?(['properties','users','emails'])
  end

  def pre_login_alerts(params)
    return if @pre_login.present?
    return 'preLoginAlerts' unless  params[:controller].in?(['users', 'registrations'])
  end

  def number_to_units(number)
    return number if number / 100000 == 0
    num = number/100000
    if num.to_s.size <= 2
      unit = Property.price_units[:l]
    elsif num.to_s.size <= 4 && num.to_s.size > 2
      num  = num / 100
      unit = Property.price_units[:c]
    elsif num.to_s.size <= 6 && num.to_s.size > 4
      num  = num / 10000
      unit = Property.price_units[:a]
    elsif num.to_s.size <= 8 && num.to_s.size > 6
      num  = num / 1000000
      unit = Property.price_units[:k]
    end
    [num, unit].join(' ')
  end

  def number_to_words(number)
    return number if number / 100000 == 0
    number_string = []
    num = number / 100000
    while num != 0
      case num.to_s.size
      when 1..2
        number_string.push(number_to_lacs(num))
        num = num / 100
      when 3..4
        number_string.push(number_to_crores(num))
        num = num % 100
      when 5..6
        number_string.push(number_to_arabs(num))
        num = num % 10000
      when 7..8
        number_string.push(number_to_kharabs(num))
        num  = num % 1000000
      end
    end
    remaining = number % 100000
    number_string.push(number_to_thousands(remaining)) unless remaining.zero?
    number_string.join(' ')
  end

  def number_to_lacs(lacs)
    join_space([lacs, Property.price_units[:l]])
  end

  def number_to_crores(number)
    crores = number / 100
    join_number(crores, Property.price_units[:c])
  end

  def number_to_arabs(number)
    arabs  = number / 10000
    join_number(arabs, Property.price_units[:a])
  end

  def number_to_kharabs(number)
    kharabs = number / 1000000
    join_number(kharabs, Property.price_units[:k])
  end

  def number_to_thousands(number)
    thousands = number / 1000
    hundreds = number % 1000
    number_in_thousands = thousands.zero? ? '' : join_space([thousands, Property.price_units[:t]])
    unless hundreds.zero?
      number_in_hundreds = number_to_hundreds(hundreds)
      return join_space([number_in_thousands, number_in_hundreds])
    end
    return join_space(['and', number_in_thousands])
  end

  def number_to_hundreds(number)
    remaining = number % 100
    hundreds = number / 100
    number_in_hundreds = hundreds.zero? ? '' : join_space([hundreds, Property.price_units[:h]])
    return join_space(['and', number_in_hundreds]) if remaining.zero?
    return join_space([number_in_hundreds, 'and', remaining])
  end

  def join_space(array)
    array.join(' ')
  end

  def join_number(number, unit)
    join_space([number, unit])
  end

end
