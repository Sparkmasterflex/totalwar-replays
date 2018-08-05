require 'rails_helper'

RSpec.describe User do
  describe "login validation" do
    let(:user)     { FactoryBot.build(:user) }
    let(:email)    { Faker::Internet.email }
    let(:username) { "#{user.first_name}_#{user.last_name}" }

    specify "user valid if has email" do
      user.email = email
      expect { user.save }.to \
        change { User.count }.by(1)
      expect(user.email)         .to eq email
      expect(user.steam_username).to be_blank
    end

    specify "user valid if has steam username" do
      user.steam_username = username
      expect { user.save }.to \
        change { User.count }.by(1)
      expect(user.email)         .to be_blank
      expect(user.steam_username).to eq username
    end

    specify "user valid if has steam username" do
      expect { user.save }.to_not \
        change { User.count }
      expect(user).to_not be_valid
    end
  end
end