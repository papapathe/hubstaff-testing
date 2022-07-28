# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe 'GET #index' do
    let!(:task1) { create(:task, project: create(:project)) }
    let!(:task2) { create(:task, project: create(:project)) }
    let(:expected_response) do
      {
        data: [{
          id: task1.id.to_s,
          type: 'task',
          attributes: {
            name: task1.name,
            description: task1.description,
            project_id: task1.project.id,
            created_at: task1.created_at.as_json,
            updated_at: task1.updated_at.as_json
          }
        }]
      }
    end
    let(:run_request) { get :index, params: { project_id: task1.project.id } }

    describe 'when user is authenticated' do
      include_context 'when user is logged in'
      it 'returns all tasks for project' do
        run_request

        expect(response).to be_ok
        expect(json_response).to eq(expected_response)
      end
    end

    context 'when token is not supplied in headers' do
      before do
        run_request
      end

      it 'returns not authorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    [nil, '', ' '].each do |value|
      context 'when token in headers is nil' do
        let(:token) { value }

        before do
          request.headers['Authorization'] = token
          run_request
        end

        it 'returns not authorized' do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe 'POST #create' do
    let(:project) { create(:project) }
    let(:task) { Task.order(id: :desc).first }
    let(:run_request) { post :create, params: params }
    let(:params) do
      { project_id: project.id, name: 'Test Name', description: 'Test Desc' }
    end

    context 'when token is not supplied in headers' do
      before { run_request }

      it { expect(response).to have_http_status(:unauthorized) }
    end

    [nil, '', ' '].each do |value|
      context 'when token in headers is nil' do
        let(:token) { value }

        before do
          request.headers['Authorization'] = nil
          run_request
        end

        it { expect(response).to have_http_status(:unauthorized) }
      end
    end

    describe 'when user is authenticated' do
      include_context 'when user is logged in'
      context 'when successfully created' do
        let(:params) do
          { project_id: project.id, name: 'Test Name', description: 'Test Desc' }
        end
        let(:expected_response) do
          {
            data: {
              id: task.id.to_s,
              type: 'task',
              attributes: {
                name: 'Test Name',
                description: 'Test Desc',
                project_id: project.id,
                created_at: Time.zone.now.as_json,
                updated_at: Time.zone.now.as_json
              }
            }
          }
        end

        it 'returns task json' do
          freeze_time do
            run_request

            expect(response).to be_ok
            expect(json_response).to eq(expected_response)
          end
        end
      end

      context 'when error occurred' do
        it 'returns errors' do
          post :create, params: { project_id: project.id }

          expect(response.status).to eq(422)
          expect(json_response).to eq(
            errors: ["Name can't be blank", "Description can't be blank"]
          )
        end
      end
    end
  end

  describe 'GET #show' do
    let(:run_request) { get :show, params: { project_id: task.project_id, id: task.id } }
    let(:task) { create(:task) }

    context 'when token is not supplied in headers' do
      before { run_request }

      it { expect(response).to have_http_status(:unauthorized) }
    end

    [nil, '', ' '].each do |value|
      context 'when token in headers is nil' do
        let(:token) { value }

        before do
          request.headers['Authorization'] = nil
          run_request
        end

        it { expect(response).to have_http_status(:unauthorized) }
      end
    end

    describe 'when user is authenticated' do
      include_context 'when user is logged in'
      context 'when task exists' do
        let(:expected_response) do
          {
            data: {
              id: task.id.to_s,
              type: 'task',
              attributes: {
                name: task.name,
                description: task.description,
                project_id: task.project_id,
                created_at: task.created_at.as_json,
                updated_at: task.updated_at.as_json
              }
            }
          }
        end

        it 'when returns task json' do
          run_request

          expect(response).to be_ok
          expect(json_response).to eq(expected_response)
        end

        context 'when task does not exist' do
          let!(:project) { create(:project) }

          it 'returns 404' do
            get :show, params: { project_id: project.id, id: 1 }

            expect(response).to be_not_found
            expect(json_response).to eq(error: 'Not Found')
          end
        end

        context 'when task does not exist for project' do
          let!(:project1) { create(:project) }
          let!(:project2) { create(:project) }

          before do
            create(:task, project: project1)
            create(:task, project: project2)
          end

          it 'returns 404' do
            get :show, params: { project_id: project1.id, id: project2.id }

            expect(response).to be_not_found
            expect(json_response).to eq(error: 'Not Found')
          end
        end
      end
    end
  end

  describe 'PATCH #update' do
    let(:params) do
      {
        project_id: task.project_id,
        id: task.id,
        name: 'Random Test Name'
      }
    end
    let(:task) { create(:task) }
    let(:run_request) { patch :update, params: params }

    context 'when token is not supplied in headers' do
      before { run_request }

      it { expect(response).to have_http_status(:unauthorized) }
    end

    [nil, '', ' '].each do |value|
      context 'when token in headers is nil' do
        let(:token) { value }

        before do
          request.headers['Authorization'] = nil
          run_request
        end

        it { expect(response).to have_http_status(:unauthorized) }
      end
    end
    describe 'when user is authenticated' do
      include_context 'when user is logged in'
      context 'when task exists' do
        context 'when successfully updated' do
          let(:params) do
            {
              project_id: task.project_id,
              id: task.id,
              name: 'Random Test Name'
            }
          end
          let(:expected_response) do
            {
              data: {
                id: task.id.to_s,
                type: 'task',
                attributes: {
                  name: 'Random Test Name',
                  description: task.description,
                  project_id: task.project_id,
                  created_at: task.created_at.as_json,
                  updated_at: Time.zone.now.as_json
                }
              }
            }
          end

          it 'returns task json' do
            freeze_time do
              run_request

              expect(response).to be_ok
              expect(json_response).to eq(expected_response)
            end
          end
        end

        context 'when error occurred' do
          let(:params) do
            {
              project_id: task.project_id,
              id: task.id,
              name: ''
            }
          end

          it 'returns errors' do
            patch :update, params: params

            expect(response.status).to eq(422)
            expect(json_response).to eq(errors: ["Name can't be blank"])
          end
        end
      end

      context 'when task does not exist' do
        let!(:project) { create(:project) }
        let(:params) do
          {
            project_id: project.id,
            id: 1,
            name: 'Test'
          }
        end

        it 'returns 404' do
          patch :update, params: params

          expect(response).to be_not_found
          expect(json_response).to eq(error: 'Not Found')
        end
      end

      context 'when task does not exist for organization' do
        let!(:task1) { create(:task, project: create(:project)) }
        let!(:task2) { create(:task, project: create(:project)) }
        let(:params) do
          {
            project_id: task1.project_id,
            id: task2.id,
            name: 'Test'
          }
        end

        it 'returns 404' do
          patch :update, params: params

          expect(response).to be_not_found
          expect(json_response).to eq(error: 'Not Found')
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:task) { create(:task) }
    let(:run_request) { delete :destroy, params: { project_id: task.project_id, id: task.id } }

    context 'when token is not supplied in headers' do
      before { run_request }

      it { expect(response).to have_http_status(:unauthorized) }
    end

    [nil, '', ' '].each do |value|
      context 'when token in headers is nil' do
        let(:token) { value }

        before do
          request.headers['Authorization'] = nil
          run_request
        end

        it { expect(response).to have_http_status(:unauthorized) }
      end
    end
    describe 'when user is authenticated' do
      include_context 'when user is logged in'
      context 'when task exists' do
        it 'returns 200' do
          run_request
          expect(response).to be_ok
        end
      end

      context 'when task does not exist' do
        let!(:project) { create(:project) }

        it 'returns 404' do
          delete :destroy, params: { project_id: project.id, id: 1 }

          expect(response).to be_not_found
          expect(json_response).to eq(error: 'Not Found')
        end
      end

      context 'when task does not exist for project' do
        let!(:task1) { create(:task, project: create(:project)) }
        let!(:task2) { create(:task, project: create(:project)) }

        it 'returns 404' do
          delete :destroy, params: { project_id: task1.project_id, id: task2.id }

          expect(response).to be_not_found
          expect(json_response).to eq(error: 'Not Found')
        end
      end
    end
  end
end
