# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    # Validation tests
    it { should validate_presence_of(:email) }
    it { should allow_value('test@example.com').for(:email) }
    it { should_not allow_value('invalid_email').for(:email) }

    # Devise-specific tests
    it { should validate_length_of(:password).is_at_least(6) }
    it { should validate_confirmation_of(:password) }

    # Devise modules
    describe 'Devise modules' do
      it { is_expected.to respond_to(:valid_password?) }
      it { is_expected.to respond_to(:send_reset_password_instructions) }
      it { is_expected.to respond_to(:remember_me) }
    end

    it 'is valid with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'is invalid without an email' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is invalid with a duplicate email' do
      create(:user, email: 'test@example.com')
      user = build(:user, email: 'test@example.com')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end

    it 'is invalid with a short password' do
      user = build(:user, password: 'short', password_confirmation: 'short')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
    end
  end

  describe 'authentication' do
    let(:user) { create(:user, password: 'password123') }

    it 'authenticates with valid credentials' do
      expect(user.valid_password?('password123')).to be_truthy
    end

    it 'fails authentication with invalid credentials' do
      expect(user.valid_password?('wrongpassword')).to be_falsey
    end
  end

  describe 'token authentication' do
    let(:user) { create(:user) }

    it 'generates a token on sign-in' do
      token = user.create_new_auth_token
      expect(token).to include('client', 'access-token', 'uid')
    end

    it 'allows sign-in with valid tokens' do
      token = user.create_new_auth_token
      expect(user.valid_token?(token['access-token'], token['client'])).to be_truthy
    end

    it 'rejects invalid tokens' do
      token = user.create_new_auth_token
      expect(user.valid_token?('wrong-token', token['client'])).to be_falsey
    end
  end

  describe 'edge cases' do
    it 'allows password and password_confirmation to match' do
      user = build(:user, password: 'password123', password_confirmation: 'password123')
      expect(user).to be_valid
    end

    it 'is invalid when password and password_confirmation do not match' do
      user = build(:user, password: 'password123', password_confirmation: 'differentpassword')
      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end
  end
end
