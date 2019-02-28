module Api
  module V1
    class OrganisationTypesController < Api::V1::ApiController
      def index
        @organisation_types = OrganisationType.all
                                              .order(params[:order])
                                              
        respond_with @organisation_types
      end
    end
  end
end
