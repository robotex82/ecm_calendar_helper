module Ecm
  module CalendarHelper
    module Controller
      # == Usage:
      # 
      # Add javascripts:
      #
      #    # app/assets/javascripts/application.js
      #    //= require ecm_calendar_helper
      #
      # Add stylesheets:  
      #
      #    # app/assets/stylesheets/application.css
      #    /*
      #     *= require ecm_calendar_helper
      #     */
      # 
      # Add routes:
      # 
      #     # config/routes.rb
      #     Rails.application.routes.draw do
      #       resources :calendars, only: [:index], constraints: ->(r) { r.xhr? } do
      #         get "(/:year/:month)", action: :index, on: :collection
      #       end
      #     end
      #
      # Add controller:
      # 
      #     # app/controllers/calendars_controller.rb
      #     class CalendarsController < ApplicationController
      #       include EcmCalendarHelper::Controller::CalendarConcern
      #   
      #       private
      #   
      #       def load_collection_for_calendar
      #         @collection = Posts.for_calendar.in_month(@date).all
      #       end
      #     end
      #
      # Add views:
      # 
      #     Copy Ecm::CalendarHelper::Engine.root.join('app/views/ecm/calendar_helper/calendar_concern/*') => app/views/calendars/
      #
      # Render the calendar somewhere in your views:
      # 
      #     # app/views/*.html.haml
      #     #calendar{ data: { calendar: calendars_url } }
      #
      #
      module CalendarConcern
        extend ActiveSupport::Concern

        included do
          before_action :initialize_calendar_date, only: [:index]
          before_action :load_collection_for_calendar, only: [:index]

          helper Ecm::CalendarHelper
          helper_method :calendar_options
        end

        def index
          if request.xhr?
            render layout: nil
          else
            render
          end
        end

        private

        def initialize_calendar_date
          @year  = params[:year]  ||= Time.zone.now.year
          @month = params[:month] ||= Time.zone.now.month

          @date = Date.strptime("#{@month}-#{@year}", "%m-%Y")
        end

        def load_collection_for_calendar
          raise 'not implemented'
        end

        def calendar_options
          default_calendar_options
        end

        def default_calendar_options
          {}
        end
      end
    end
  end
end