# encoding: utf-8
module ApplicationHelper
  
  def title(page_title, header_title = "", badge = {} )
    content_for(:title) { page_title }
    header_title = page_title if header_title.empty?
    content_for(:title2) { content_tag(:div, header_title, :class => 'title')}
    if badge['proposal'] == 1 && badge['discount'] == 1
      content_for(:title2) { content_tag(:a, "", :class => 'gift popover-gift', :href => "#discount") }
      content_for(:title2) { content_tag(:a, "", :class => 'proposal popover-proposal', :href => "#proposal" ) }
    elsif badge['discount'] == 0 && badge['proposal'] == 1
      content_for(:title2) { content_tag(:a, "", :class => 'proposal popover-proposal', :href => "#proposal" ) }
    elsif badge['proposal'] == 0 && badge['discount'] == 1
      content_for(:title2) { content_tag(:a, "", :class => 'gift popover-gift', :href => "#discount") }
    end

  end

  def tabs(current_tab, page_title = nil)
    content_for(:title) { page_title || current_tab }
    content_for :tabs do
      tabs = %w{Vestidos Acessórios Lojas}
      content_tag :ul do
        tabs.collect {|t| concat(content_tag(:li, 
          link_to(t, "", :class => (current_tab == t ? "active" : "inactive")))
        )}
      end
    end
  end
    
  def rating_average_stars(rating_average)
    100*rating_average/5
  end
  
	def sortable(column, title = nil)
	  title ||= column.titleize
	  css_class = column == sort_column ? "current #{sort_direction}" : nil
	  direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
	  link_to title, {:sort => column, :direction => direction}, {:class => css_class}
	end

  def count_rows(type,value)
    hash = Hash.new()
    hash[type] = value
    conditions = { :conditions => hash}
    Dress.find(:all, conditions).count
  end

  def count_matches(array, attribute, value)
    array.collect{|obj| obj.send(attribute) == value}.delete_if{|x| x == false}.size
  end

  def profile_sidebar_count(type)
    if type == 'favorites_vendors'
      @user.bookmarks.where("bookmarkable_type = ?", "Vendor").size
    elsif type == 'favorites_dresses'
      @user.bookmarks.where("bookmarkable_type = ?", "Dress").size
    elsif type == 'quotations'
      @user.quotations.size
    elsif type == 'appointments'
      @user.appointments.size
    elsif type == 'reviews'
      @user.reviews.size
    end
  end

  def price_to_dollar(price)
    if price.eql?(1)
      "$"
    elsif price.eql?(2)
      "$$"
    elsif price.eql?(3)
      "$$$"
    elsif price.eql?(4)
      "$$$$"
    elsif price.eql?(5)
      "$$$$$"
    end
  end

  def selected_category(type)
    Review.joins(:vendor).where("reviews.user_id = ? AND vendors.type = ?", current_user.id, type).size > 0 
  end

  def daily_review_random
      data = DateTime.now()
      #data = Date.today.beginning_of_day
      if data == Date.today.beginning_of_day
        @daily_review_random ||= Review.random_ordem.limit(1).collect
      else
        @daily_review_random ||= Review.order("created_at DESC").limit(1)
      end
  end

  def is_home?
    if ( request.path_parameters[:action] == "new" ) && ( request.path_parameters[:controller] == "searches" ) 
      return true
    elsif ( request.path_parameters[:action] == "show" ) && ( request.path_parameters[:controller] == "searches" ) 
      return true
    else 
      false
    end
  end

  def current_progress_merits(user)
    points = user.user_merits_info.points
    maxscore = 200 #Merit::MAXSCORE["#{user.user_merits_info.merit.merits_type}"]
    if points != 0
      100*(points)/maxscore
    else
      points
    end

  end

end
