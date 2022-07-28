# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionService do
  describe '#create' do
    subject(:result) { described_class.new.create!(params) }

    let(:user) { create(:user) }
    let(:params) { ActionController::Parameters.new({ name: user.name, password: user.password }) }

    it { expect(result).to eq(user) }

    context 'when user does not exist' do
      let(:params) { { name: 'not_known', password: user.password } }

      it { expect { result }.to raise_error(ApiError) }
    end

    context 'with existing user and bad password' do
      let(:params) { { name: user.name, password: 'badpassword' } }

      it { expect { result }.to raise_error(ApiError) }
    end

    context 'when params is nil' do
      let(:params) { nil }

      it { expect { result }.to raise_error(ApiError) }
    end

    context 'when params is a string' do
      let(:params) { 'blaaah' }

      it { expect { result }.to raise_error(ApiError) }
    end
  end
end
