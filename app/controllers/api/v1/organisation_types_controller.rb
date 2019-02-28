module Api
  module V1
    class OrganisationTypesController < Api::V1::ApiController
      def index
        @organisation_types = OrganisationType.all
          .order(helpers.to_activerecord_order_clause(params[:sort]))
          .limit(helpers.to_limit(params))
          .offset(helpers.to_offset(params))
        respond_with @organisation_types
      end
    end
  end
end
