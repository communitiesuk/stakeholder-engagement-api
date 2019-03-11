module Api
  module V1
    class PeopleController < Api::V1::ApiController
      def index
        @people = helpers.paginate(
          Person.all
            .order(helpers.to_activerecord_order_clause(params[:sort]))
        )
        authorize @people
        respond_with @people, include: [roles: [:organisation, :role_type, :region]]
      end

      def show
        @person = Person.friendly.find(params[:id])
        authorize @person
        respond_with @person, include: [roles: [:organisation, :role_type, :region]]
      end

      def create
        @person = Person.new(person_params)
        authorize @person
        @person.save!
        response.headers['Location'] = url_for([:api, :v1, @person])

        respond_with  @person,  status: :created,
                                include: [roles: [:organisation, :role_type, :region]]
      end

      def update
        @person = Person.friendly.find(params[:id])
        authorize @person
        @person.update!(person_params)
        respond_with  @person,  status: :ok,
                                include: [roles: [:organisation, :role_type, :region]]
      end

      def destroy
        @person = Person.friendly.find(params[:id])
        authorize @person
        @person.destroy!
        render jsonapi: nil, status: :no_content
      end

      private

      def person_params(opts = params)
        opts.require(:data).require(:attributes).permit(:name, :slug, :title)
      end
    end
  end
end
