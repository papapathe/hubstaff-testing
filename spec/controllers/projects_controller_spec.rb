require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe 'GET #index' do
    let!(:organization1) { create(:organization) }
    let!(:organization2) { create(:organization) }
    let!(:project1) { create(:project, organization: organization1) }
    let!(:project2) { create(:project, organization: organization2) }

    it 'returns all projects for organization' do
      get :index, params: {organization_id: organization1.id}

      expect(response).to be_ok
      expect(json_response).to eq(
        data: [{
          id: project1.id.to_s,
          type: 'project',
          attributes: {
            name: project1.name,
            organization_id: organization1.id,
            created_at: project1.created_at.as_json,
            updated_at: project1.updated_at.as_json
          }
        }]
      )
    end
  end

  describe 'POST #create' do
    let(:organization) { create(:organization) }
    let(:project) { Project.order(id: :desc).first }

    context 'successfully created' do
      it 'returns project json' do
        freeze_time do
          post :create, params: {organization_id: organization.id, name: 'Test Name'}

          expect(response).to be_ok
          expect(json_response).to eq(
            data: {
              id: project.id.to_s,
              type: 'project',
              attributes: {
                name: 'Test Name',
                organization_id: organization.id,
                created_at: Time.zone.now.as_json,
                updated_at: Time.zone.now.as_json
              }
            }
          )
        end
      end
    end

    context 'error occurred' do
      it 'returns errors' do
        post :create, params: {organization_id: organization.id}

        expect(response.status).to eq(422)
        expect(json_response).to eq(
          errors: ["Name can't be blank"]
        )
      end
    end
  end

  describe 'GET #show' do
    context 'project exists' do
      let(:project) { create(:project) }

      it 'returns project json' do
        get :show, params: {organization_id: project.organization_id, id: project.id}

        expect(response).to be_ok
        expect(json_response).to eq(
          data: {
            id: project.id.to_s,
            type: 'project',
            attributes: {
              name: project.name,
              organization_id: project.organization_id,
              created_at: project.created_at.as_json,
              updated_at: project.updated_at.as_json
            }
          }
        )
      end
    end

    context 'project does not exist' do
      let!(:organization) { create(:organization) }

      it 'returns 404' do
        get :show, params: {organization_id: organization.id, id: 1}

        expect(response).to be_not_found
        expect(json_response).to eq(error: 'Not Found')
      end
    end

    context 'project does not exist for organization' do
      let!(:organization1) { create(:organization) }
      let!(:organization2) { create(:organization) }
      let!(:project1) { create(:project, organization: organization1) }
      let!(:project2) { create(:project, organization: organization2) }

      it 'returns 404' do
        get :show, params: {organization_id: organization1.id, id: project2.id}

        expect(response).to be_not_found
        expect(json_response).to eq(error: 'Not Found')
      end
    end
  end

  describe 'PATCH #update' do
    context 'project exists' do
      let(:project) { create(:project) }

      context 'successfully updated' do
        it 'returns project json' do
          freeze_time do
            patch :update, params: {
              organization_id: project.organization_id,
              id: project.id,
              name: 'Random Test Name'
            }
  
            expect(response).to be_ok
            expect(json_response).to eq(
              data: {
                id: project.id.to_s,
                type: 'project',
                attributes: {
                  name: 'Random Test Name',
                  organization_id: project.organization_id,
                  created_at: project.created_at.as_json,
                  updated_at: Time.zone.now.as_json
                }
              }
            )
          end
        end
      end

      context 'error occurred' do
        it 'returns errors' do
          patch :update, params: {
            organization_id: project.organization_id,
            id: project.id,
            name: ''
          }

          expect(response.status).to eq(422)
          expect(json_response).to eq(
            errors: ["Name can't be blank"]
          )
        end
      end
    end

    context 'project does not exist' do
      let!(:organization) { create(:organization) }

      it 'returns 404' do
        patch :update, params: {
          organization_id: organization.id,
          id: 1,
          name: 'Test'
        }

        expect(response).to be_not_found
        expect(json_response).to eq(error: 'Not Found')
      end
    end

    context 'project does not exist for organization' do
      let!(:organization1) { create(:organization) }
      let!(:organization2) { create(:organization) }
      let!(:project1) { create(:project, organization: organization1) }
      let!(:project2) { create(:project, organization: organization2) }

      it 'returns 404' do
        patch :update, params: {
          organization_id: organization1.id,
          id: project2.id,
          name: 'Test'
        }

        expect(response).to be_not_found
        expect(json_response).to eq(error: 'Not Found')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'project exists' do
      let(:project) { create(:project) }

      it 'returns 200' do
        delete :destroy, params: {organization_id: project.organization_id, id: project.id}
        expect(response).to be_ok
      end
    end

    context 'project does not exist' do
      let!(:organization) { create(:organization) }

      it 'returns 404' do
        delete :destroy, params: {organization_id: organization.id, id: 1}

        expect(response).to be_not_found
        expect(json_response).to eq(error: 'Not Found')
      end
    end

    context 'project does not exist for organization' do
      let!(:organization1) { create(:organization) }
      let!(:organization2) { create(:organization) }
      let!(:project1) { create(:project, organization: organization1) }
      let!(:project2) { create(:project, organization: organization2) }

      it 'returns 404' do
        delete :destroy, params: {organization_id: organization1.id, id: project2.id}

        expect(response).to be_not_found
        expect(json_response).to eq(error: 'Not Found')
      end
    end
  end
end
