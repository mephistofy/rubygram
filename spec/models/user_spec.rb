# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    subject { create(:user) }

    it { is_expected.to have_many(:post) }

    it { is_expected.to have_many(:active_follows).with_foreign_key(:follower_id).class_name('Follow') }
    it { is_expected.to have_many(:following).through(:active_follows).source(:followed) }

    it { is_expected.to have_many(:passive_follows).with_foreign_key(:followed_id).class_name('Follow') }
    it { is_expected.to have_many(:followers).through(:passive_follows).source(:follower) }
  end

  describe 'validations' do
    context 'with rigth atrributes' do
      it { is_expected.to validate_presence_of(:email) }
    end

    context 'with wrong attributes' do
      it 'should not create a user with not image avatar format' do
        subject { create(:user, with_invalid_avatar) }

        is_expected.to be_invalid
      end

      it 'should not create user with short password' do
        subject { create(:user, with_invalid_short_password) }

        is_expected.to be_invalid
      end

      it 'should not create user with password confirmation dismatch' do
        subject { create(:user, with_password_confirmation_dismath) }

        is_expected.to be_invalid
      end

      it 'with not an email' do
        subject { create(:user, with_not_an_email) }

        is_expected.to be_invalid
      end
    end
  end

  describe 'follow methods' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    before { user1.follow(user2) }

    context 'follow' do
      it 'is expected to follow succesfully' do
        expect(user1.following?(user2)).to eq(true)
      end
    end

    context 'unfollow' do
      it 'is expected to unfollow succesfully' do
        user1.unfollow(user2)

        expect(user1.following?(user2)).to eq(false)
      end
    end

    context 'following?' do
      it 'is expected to have following check work right way' do
        expect(user1.following?(user2)).to eq(true)
        expect(user2.following?(user1)).to eq(false)
      end
    end
  end
end
