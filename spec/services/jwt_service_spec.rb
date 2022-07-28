# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JwtService do
  let(:alg) { 'HS256' }
  let(:secret) { 'not_a_secret' }

  describe '#encode' do
    subject(:result) { described_class.new.encode(user: user, algorithm: alg, secret: secret) }

    before { allow(JWT).to receive(:encode) }

    let(:user) { create(:user) }
    let(:expected_params) { { user_id: user.id, last_login_secret: user.last_login_secret } }

    it 'delegates work to jwt' do
      result
      expect(JWT).to have_received(:encode).with(expected_params, secret, alg)
    end
  end

  describe '#decode' do
    subject(:result) { described_class.new.decode('a.jwt.string', secret, { alg: alg }) }

    before { allow(JWT).to receive(:decode) }

    it 'delegates work to jwt' do
      result
      expect(JWT).to have_received(:decode).with('a.jwt.string', secret, { alg: alg })
    end
  end
end
