# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
  describe 'GET #show' do
    let!(:organization) { create(:organization) }
    let(:run_request) { get :show, params: { id: organization.id } }

    context 'when user is authtenticated' do
      include_context 'when user is logged in'
      context 'when organization exists' do
        let(:expected_response) do
          {
            data: {
              id: organization.id.to_s,
              type: 'organization',
              attributes: {
                name: organization.name,
                created_at: organization.created_at.as_json
              }
            }
          }
        end

        it 'returns organization json' do
          run_request

          expect(response).to be_ok
          expect(json_response).to eq(expected_response)
        end
      end

      context 'when organization does not exist' do
        it 'returns 404' do
          get :show, params: { id: 1 }

          expect(response).to be_not_found
          expect(json_response).to eq(error: 'Not Found')
        end
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
          request.headers['Authorization'] = nil
          run_request
        end

        it 'returns not authorized' do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end
