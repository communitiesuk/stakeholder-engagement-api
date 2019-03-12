module Api
  module V1
    class PolicyAreasController < Api::V1::ApiController
      def index
        @policy_areas = helpers.paginate(
          PolicyArea.all
            .order(helpers.to_activerecord_order_clause(params[:sort], PolicyArea))
        )
        authorize @policy_areas
        respond_with @policy_areas
      end

      def show
        @policy_area = PolicyArea.friendly.find(params[:id])
        authorize @policy_area
        respond_with @policy_area
      end

      def create
        @policy_area = PolicyArea.new(create_policy_area_params)
        authorize @policy_area
        @policy_area.save!
        response.headers['Location'] = url_for([:api, :v1, @policy_area])

        respond_with  @policy_area, status: :created
      end

      def update
        @policy_area = PolicyArea.friendly.find(params[:id])
        authorize @policy_area
        @policy_area.update!(policy_area_params)
        respond_with  @policy_area, status: :ok
      end

      def destroy
        @policy_area = PolicyArea.friendly.find(params[:id])
        authorize @policy_area
        @policy_area.destroy!
        render jsonapi: nil, status: :no_content
      end

      private

      def create_policy_area_params(opts = params)
        policy_area_params(opts)
      end

      def policy_area_params(opts = params)
        opts.require(:data)
              .require(:attributes)
                .permit(:name, :slug)
      end
    end
  end
end
