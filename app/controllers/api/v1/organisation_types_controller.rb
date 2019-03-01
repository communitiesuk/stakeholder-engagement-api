module Api
  module V1
    class OrganisationTypesController < Api::V1::ApiController
      def index
        @organisation_types = helpers.paginate(
          OrganisationType.all
            .order(helpers.to_activerecord_order_clause(params[:sort]))
        )

        respond_with @organisation_types
      end
    end
  end
end
