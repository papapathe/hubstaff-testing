# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Authenticator do
  let(:instance) { described_class.new }

  describe '#authenticate' do
    subject(:result) { instance.authenticate!(token) }

    context 'when token is nil' do
      let(:token) { nil }

      it { expect { result }.to raise_error(ArgumentError) }
    end

    context 'when token is empty string' do
      let(:token) { '' }

      it { expect { result }.to raise_error(ArgumentError) }
    end

    context 'when token is valid' do
      let(:jwt) do
        JWT.encode(
          { user_id: user.id, last_login_secret: user.last_login_secret },
          'secret',
          'HS256'
        )
      end
      let(:token) { MessageEncryptorService.new(jwt).encrypt }
      let(:user) { create(:user) }

      it 'returns the user' do
        expect(result).to eq(user)
      end
    end
  end
end
