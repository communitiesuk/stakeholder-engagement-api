module Api
  module V1
    class RoleTypesController < Api::V1::ApiController
      def index
        @role_types = helpers.paginate(
          RoleType.all
            .order(helpers.to_activerecord_order_clause(params[:sort], RoleType))
        )
        authorize @role_types
        respond_with @role_types
      end

      def show
        @role_type = RoleType.friendly.find(params[:id])
        authorize @role_type
        respond_with @role_type
      end

      def create
        @role_type = RoleType.new(role_type_params)
        authorize @role_type
        @role_type.save!
        response.headers['Location'] = url_for([:api, :v1, @role_type])

        respond_with  @role_type, status: :created
      end

      def update
        @role_type = RoleType.friendly.find(params[:id])
        authorize @role_type
        @role_type.update!(role_type_params)
        respond_with  @role_type, status: :ok
      end

      def destroy
        @role_type = RoleType.friendly.find(params[:id])
        authorize @role_type
        @role_type.destroy!
        render jsonapi: nil, status: :no_content
      end

      private

      def role_type_params(opts = params)
        opts.require(:data).require(:attributes).permit(:name, :slug)
      end
    end
  end
end
