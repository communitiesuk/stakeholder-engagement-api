module Api
  module V1
    class OrganisationTypesController < Api::V1::ApiController
      def index
        @organisation_types = helpers.paginate(
          OrganisationType.all
            .order(helpers.to_activerecord_order_clause(params[:sort]))
        )
        authorize @organisation_types
        respond_with @organisation_types
      end

      def show
        @organisation_type = OrganisationType.friendly.find(params[:id])
        authorize @organisation_type
        respond_with @organisation_type
      end
    end
  end
end
