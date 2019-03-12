module Api
  module V1
    class EngagementPolicyAreasController < Api::V1::ApiController
      def index
        @engagement_policy_areas = helpers.paginate(
          EngagementPolicyArea.includes(:policy_area, :engagement).all
            .order(helpers.to_activerecord_order_clause(params[:sort], EngagementPolicyArea))
        )
        authorize @engagement_policy_areas
        respond_with @engagement_policy_areas,  include: [:engagement, :policy_area]
      end

      def show
        @engagement_policy_area = EngagementPolicyArea.find(params[:id])
        authorize @engagement_policy_area
        respond_with @engagement_policy_area,  include: [:engagement, :policy_area]
      end

      def create
        @engagement_policy_area = EngagementPolicyArea.new(engagement_policy_area_params)
        authorize @engagement_policy_area
        @engagement_policy_area.save!
        response.headers['Location'] = url_for([:api, :v1, @engagement_policy_area])

        respond_with  @engagement_policy_area,  status: :created,
                                      include: [:engagement, :policy_area]
      end

      def update
        @engagement_policy_area = EngagementPolicyArea.find(params[:id])
        authorize @engagement_policy_area
        @engagement_policy_area.update!(engagement_policy_area_params)
        respond_with  @engagement_policy_area, status: :ok,
                                     include: [:engagement, :policy_area]
      end

      def destroy
        @engagement_policy_area = EngagementPolicyArea.find(params[:id])
        authorize @engagement_policy_area
        @engagement_policy_area.destroy!
        render jsonapi: nil, status: :no_content
      end

      private

      def engagement_policy_area_params(opts = params)
        opts.require(:data).require(:attributes).permit(:engagement_id, :policy_area_id)
      end
    end
  end
end
