module Ecm
  module CalendarHelper
    # renders a calendar table
    def month_calendar(date = Time.zone.now.to_date, elements = [], options = {})
      options.reverse_merge! :date_method => :start_at, :display_method => :to_s, :link_elements => true, :start_day => :sunday

      display_method = options.delete(:display_method)
      link_elements  = options.delete(:link_elements)
      
      # calculate beginning and end of month
      beginning_of_month = date.beginning_of_month.to_date
      end_of_month = date.end_of_month.to_date

      # Get localized day names
      localized_day_names = I18n.t('date.abbr_day_names').dup

      # Shift day names to suite start day
      english_day_names = [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]

      # Raise an exception if the passed start day is not an english day name
      raise ":start_day option for month_calendar must be in: #{english_day_names.join(', ')}, but you passed: #{options[:start_day].to_s} (class: #{options[:start_day].class.to_s})" unless english_day_names.include?(options[:start_day])

      # Get the offset of start day
      offset = english_day_names.index(options[:start_day])
      last_day_of_week =  Time.zone.now.end_of_week.wday


      # Change calendar heading if offset is not 0 (offset 0 means sunday is the first day of the week)
      offset.times do 
        localized_day_names.push(localized_day_names.shift)
      end

      days_by_week = {}
      first_day = beginning_of_month.beginning_of_week
      last_day = end_of_month.end_of_week

      days = (first_day..last_day).each_with_object({}).with_index do |(day, memo), index|
        memo[day.to_date] = elements.find_all { |e| e.send(options[:date_method]).to_date == day.to_date } || {}
      end

      days_by_week = days.each_with_object({}) { |(k, v), m| (m[k.cweek] ||= {})[k] = v }

      render partial: 'ecm/calendar_helper/month_calendar', locals: { localized_day_names: localized_day_names, days_by_week: days_by_week, display_method: display_method, link_elements: link_elements }
    end
    
    def month_calendar_pagination(date, options = {})
      options.reverse_merge!(show_today_link: true)

      show_today_link = options.delete(:show_today_link)

      actual_month   = Time.zone.now.beginning_of_month.to_date
      previous_month = date.beginning_of_month.to_date - 1.month
      next_month     = date.beginning_of_month.to_date + 1.months

      render partial: 'ecm/calendar_helper/month_calendar_pagination', locals: { actual_month: actual_month, previous_month: previous_month, next_month: next_month, show_today_link: show_today_link, date: date }
    end
  end
end  
