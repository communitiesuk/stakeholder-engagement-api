module Api
  module V1
    class ApiController < ApplicationController
      before_action :stub_current_user!

      include Pundit
      after_action :verify_authorized

      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
      rescue_from ActionController::ParameterMissing, with: :bad_request
      rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity

      # we have no concept of user identity yet, but Pundit requires a
      # current_user method
      def stub_current_user!
        @current_user = nil
      end
      def current_user
        @current_user
      end

      def jsonapi_pagination(collection)
        {
          first: helpers.first_page_link(collection),
          last: helpers.last_page_link(collection),
          prev: helpers.previous_page_link(collection),
          next: helpers.next_page_link(collection)
        } if collection.respond_to?(:current_page)
      end

      private

      # HACK - force everything to render as JSON
      # Fixes issue with Node client library on frontend
      def respond_with(data, args={})
        if true || request.format.json?
          render jsonapi: data, status: args[:status],
                                include: args[:include],
                                fields: args[:fields]
        end
      end

      def not_found(exception)
        render json: {error: exception}, status: :not_found
      end

      def bad_request(exception)
        render json: {error: exception}, status: :bad_request
      end

      def unprocessable_entity(exception)
        render json: {error: exception}, status: :unprocessable_entity
      end

      def user_not_authorized(exception)
        policy_name = exception.policy.class.to_s.underscore

        render json: {error: exception}, status: :forbidden
      end
    end
  end
end
