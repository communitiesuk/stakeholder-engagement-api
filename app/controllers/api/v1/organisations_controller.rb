module Api
  module V1
    class OrganisationsController < Api::V1::ApiController
      def index
        @organisations = helpers.paginate(
          Organisation.all
            .order(helpers.to_activerecord_order_clause(params[:sort]))
        )
        authorize @organisations
        respond_with @organisations,  include: [:organisation_type, :region]
      end

      def show
        @organisation = Organisation.friendly.find(params[:id])
        authorize @organisation
        respond_with @organisation,  include: [:organisation_type, :region]
      end

      def create
        @organisation = Organisation.new(organisation_params)
        authorize @organisation
        @organisation.save!
        response.headers['Location'] = url_for([:api, :v1, @organisation])

        respond_with  @organisation,  status: :created,
                                      include: [:organisation_type, :region]
      end

      def update
        @organisation = Organisation.friendly.find(params[:id])
        authorize @organisation
        @organisation.update!(organisation_params)
        respond_with  @organisation, status: :ok,
                                     include: [:organisation_type, :region]
      end

      def destroy
        @organisation = Organisation.friendly.find(params[:id])
        authorize @organisation
        @organisation.destroy!
        render jsonapi: nil, status: :no_content
      end

      private

      def organisation_params(opts = params)
        opts.require(:data).require(:attributes).permit(:name, :slug, :organisation_type_id, :region_id)
      end
    end
  end
end
