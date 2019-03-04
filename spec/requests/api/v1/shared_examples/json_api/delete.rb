# Requires these methods to be defined in the containing scope:
# model_instance
# url
RSpec.shared_examples 'a JSON:API-compliant delete method' do |model_class|
  let(:perform_request) do
    delete url, params: params, headers: headers
  end
  let(:policy_class) do
    Pundit::PolicyFinder.new(model_instance).policy!
  end

  context 'when the current user is not authorized to delete the entity' do
    before do
      allow_any_instance_of(policy_class).to receive(:destroy?).and_return(false)
    end

    it 'returns status forbidden' do
      perform_request
      expect(response).to have_http_status(:forbidden)
    end

    it 'does not delete the entity' do
      expect{ perform_request }.to_not change(model_instance.class, :count)
    end

  end

  context 'when the current user is authorized to delete the entity' do
    before do
      allow_any_instance_of(policy_class).to receive(:destroy?).and_return(true)
    end

    it 'deletes the entity' do
      expect{ perform_request }.to change(model_instance.class, :count).by(-1)
    end

    describe 'the response' do
      it 'has status 204 No Content' do
        perform_request
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
