module Api
  module V1
    class ApiController < ApplicationController

      rescue_from ActiveRecord::RecordNotFound, with: :not_found

      def jsonapi_pagination(collection)
        {
          first: helpers.first_page_link(collection),
          last: helpers.last_page_link(collection),
          prev: helpers.previous_page_link(collection),
          next: helpers.next_page_link(collection)
        } if collection.respond_to?(:current_page)
      end

      private

      def respond_with(data)
        if request.format.json?
          render jsonapi: data
        end
      end

      def not_found(e)
        render json: {error: e}, status: :not_found
      end

    end
  end
end
