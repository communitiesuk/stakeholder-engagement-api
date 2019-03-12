module Api
  module V1
    class RolesController < Api::V1::ApiController
      def index
        @roles = helpers.paginate(
          Role.all
            .order(helpers.to_activerecord_order_clause(params[:sort], Role))
        )
        authorize @roles
        respond_with @roles,  include: [:organisation, :person, :role_type, :region]
      end

      def show
        @role = Role.friendly.find(params[:id])
        authorize @role
        respond_with @role,  include: [:organisation, :person, :role_type, :region]
      end

      def create
        @role = Role.new(role_params)
        authorize @role
        @role.save!
        response.headers['Location'] = url_for([:api, :v1, @role])

        respond_with  @role,  status: :created,
                                      include: [:organisation, :person, :role_type, :region]
      end

      def update
        @role = Role.friendly.find(params[:id])
        authorize @role
        @role.update!(role_params)
        respond_with  @role, status: :ok,
                                     include: [:organisation, :person, :role_type, :region]
      end

      def destroy
        @role = Role.friendly.find(params[:id])
        authorize @role
        @role.destroy!
        render jsonapi: nil, status: :no_content
      end

      private

      def role_params(opts = params)
        opts.require(:data).require(:attributes).permit(:title, :slug, :organisation_id, :person_id, :role_type_id, :region_id)
      end
    end
  end
end
