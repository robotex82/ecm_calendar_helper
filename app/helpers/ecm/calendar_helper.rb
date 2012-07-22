module Ecm
  module CalendarHelper
    # renders a calendar table
    def month_calendar(date = Time.zone.now.to_date, elements = [], options = {})
      # default options
      options.reverse_merge! :date_method => :start_at, :display_method => :to_s, :link_elements => true, :start_day => :sunday
      
      # calculate beginning and end of month
      beginning_of_month = date.beginning_of_month.to_date
      end_of_month = date.end_of_month.to_date

      # Get localized day names
      localized_day_names = I18n.t('date.day_names').dup

      # Shift day names to suite start day
      english_day_names = [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]

      # Raise an exception if the passed start day is not an english day name
      raise ":start_day option for month_calendar must be in: #{english_day_names.join(', ')}, but you passed: #{options[:start_day].to_s} (class: #{options[:start_day].class.to_s})" unless english_day_names.include?(options[:start_day])

      # Get the offset of start day
      offset = english_day_names.index(options[:start_day])


      # Change calendar heading if offset is not 0 (offset 0 means sunday is the first day of the week)
      offset.times do 
        localized_day_names.push(localized_day_names.shift)
      end
    
      content_tag(:table, :class => 'calendar') do
        table = ''
        
        table << content_tag(:tr,  localized_day_names.collect { |day| content_tag(:th, day) }.join("").html_safe)
        table << content_tag(:tr) do
          table_content = ''
          
          (beginning_of_month..end_of_month).each do |d|
            if d == beginning_of_month
              column_offset = d.wday - offset
              column_offset += 7 if column_offset < 0
              column_offset.times do
                table_content << content_tag(:td, nil, :class => 'offset')
              end
            end
             
            if d.wday == (0 + offset)
               table_content << "</tr><tr>"
            end
             
            # Create content for day
            day_content = "#{d.day}<br/ >".html_safe
            elements_for_day = elements.find_all { |e| e.send(options[:date_method]).to_date == d.to_date }
            if options[:link_elements]
              elements_for_day.collect! { |e| content_tag(:div, link_to(e.send(options[:display_method]), e), :class => 'calendar_entry') }
            else
              elements_for_day.collect! { |e| content_tag(:div, e.send(options[:display_method]), :class => 'calendar_entry') }
            end
            
            day_content << elements_for_day.join("").html_safe
            
            # css classes for day td
            if d == Time.zone.now.to_date
              day_css_classes = 'calendar_day today'
            else
              day_css_classes = 'calendar_day'
            end 
            
            table_content << content_tag(:td, day_content, :class => day_css_classes)
          end
          
          table_content.html_safe
        end
        
        table.html_safe
      end
    end
    
    def month_calendar_pagination(date)
      actual_month = Time.zone.now.beginning_of_month.to_date
   
      previous_month = date.beginning_of_month.to_date - 1.month
      next_month = date.beginning_of_month.to_date + 1.months      
      
      content_tag(:div, :class => 'calendar_pagination') do
        [
          link_to('Heute', url_for(:month => actual_month.month, :year => actual_month.year)),
          link_to("<", url_for(:month => previous_month.month, :year => previous_month.year)),
          link_to(">", url_for(:month => next_month.month, :year => next_month.year)),
          I18n.l(date, :format => :month_with_year),
        ].join(" | ").html_safe
      end
    end
  end
end  
