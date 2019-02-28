module Api
  module V1
    class ApiController < ApplicationController
      protected

      def respond_with(data)
        if request.format.json?
          render jsonapi: data
        end
      end
    end
  end
end
