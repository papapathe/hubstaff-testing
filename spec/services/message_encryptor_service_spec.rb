# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessageEncryptorService do
  let(:instance) { described_class.new 'a.crypted.message' }

  describe '#initialize' do
    it { expect(instance.message).to eq('a.crypted.message') }
    it { expect(instance.encryptor).to be_a(ActiveSupport::MessageEncryptor) }
  end

  describe '#encrypt' do
    it do
      allow(instance.encryptor).to receive(:encrypt_and_sign)
      instance.encrypt
      expect(instance.encryptor).to have_received(:encrypt_and_sign).with(instance.message)
    end
  end

  describe '#decrypt' do
    it do
      allow(instance.encryptor).to receive(:decrypt_and_verify)
      instance.decrypt
      expect(instance.encryptor).to have_received(:decrypt_and_verify).with(instance.message)
    end
  end
end
