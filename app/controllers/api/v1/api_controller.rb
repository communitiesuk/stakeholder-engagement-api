module Api
  module V1
    class ApiController < ApplicationController
      protected

      def respond_with(data)
        render json: data if request.format.json?
      end
    end
  end
end
