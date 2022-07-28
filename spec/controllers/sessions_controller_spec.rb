# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController do
  describe '#create' do
    let(:user) { create :user }
    let(:session_params) { { name: user.name, password: user.password } }
    let(:do_request) { post :create, params: session_params }
    let(:expected_response) do
      {
        data: {
          id: user.id.to_s,
          type: 'user_session',
          attributes: {
            name: user.name,
            token: 'atoken'
          }
        }
      }.deep_stringify_keys
    end
    let(:my_instance) { instance_double(MessageEncryptorService) }

    it 'logins succesfully' do
      do_request
      expect(response).to have_http_status(:created)
    end

    it 'returns the token' do
      allow(MessageEncryptorService).to receive(:new).and_return(my_instance)
      allow(my_instance).to receive(:encrypt).and_return('atoken')
      do_request
      expect(response.parsed_body).to eq(expected_response)
    end

    context 'when user is in database but password auth fails' do
      let(:session_params) { { name: user.name, password: 'aweakpwd' } }

      it 'returns status unauthorized' do
        do_request
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is not in database' do
      let(:session_params) { { name: 'user@app.com', password: 'aweakpwd' } }

      it 'returns status unauthorized' do
        do_request
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
