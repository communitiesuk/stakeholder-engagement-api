module Api
  module V1
    class RegionsController < Api::V1::ApiController
      def index
        @regions = helpers.paginate(
          Region.all
            .order(helpers.to_activerecord_order_clause(params[:sort]))
        )
        authorize @regions
        respond_with @regions
      end

      def show
        @region = Region.friendly.find(params[:id])
        authorize @region
        respond_with @region
      end

      def create
        @region = Region.new(create_region_params)
        authorize @region
        @region.save!
        response.headers['Location'] = url_for([:api, :v1, @region])

        respond_with  @region, status: :created
      end

      def update
        @region = Region.friendly.find(params[:id])
        authorize @region
        @region.update!(region_params)
        respond_with  @region, status: :ok
      end

      def destroy
        @region = Region.friendly.find(params[:id])
        authorize @region
        @region.destroy!
        render jsonapi: nil, status: :no_content
      end

      private

      def create_region_params(opts = params)
        region_params(opts)
      end

      def region_params(opts = params)
        opts.require(:data)
              .require(:attributes)
                .permit(:name, :nuts_code, :slug)
      end
    end
  end
end
