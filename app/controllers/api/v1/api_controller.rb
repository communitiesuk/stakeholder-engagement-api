module Api
  module V1
    class ApiController < ApplicationController
      def jsonapi_pagination(collection)
        {
          first: helpers.first_page_link(collection),
          last: helpers.last_page_link(collection),
          prev: helpers.previous_page_link(collection),
          next: helpers.next_page_link(collection)
        }
      end

      protected

      def respond_with(data)
        if request.format.json?
          render jsonapi: data
        end
      end

    end
  end
end
