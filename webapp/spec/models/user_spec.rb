# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

    context "when creating a user" do
      it { is_expected.to validate_presence_of(:password) }
      it { is_expected.to validate_length_of(:password).is_at_least(8) }

      it "validates password format with lowercase and uppercase" do
        user = build(:user, password: "password123", password_confirmation: "password123")
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("must contain at least one lowercase and one uppercase letter")

        user.password = "Password123"
        user.password_confirmation = "Password123"
        expect(user).to be_valid
      end
    end

    context "when updating a user" do
      let(:user) { create(:user) }

      it "allows blank password on update" do
        expect(user.update(name: "Updated Name")).to be_truthy
      end

      it "validates password format when password is provided" do
        expect(user.update(password: "password123", password_confirmation: "password123")).to be_falsey
        expect(user.errors[:password]).to include("must contain at least one lowercase and one uppercase letter")

        expect(user.update(password: "Password123", password_confirmation: "Password123")).to be_truthy
      end
    end
  end

  describe "Devise modules" do
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:encrypted_password) }
    it { is_expected.to respond_to(:reset_password_token) }
    it { is_expected.to respond_to(:confirmation_token) }
    it { is_expected.to respond_to(:confirmed_at) }
  end
end
