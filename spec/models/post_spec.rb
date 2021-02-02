# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'assosiations' do
    subject { create(:post) }

    it { is_expected.to have_many(:comment) }
    it { is_expected.to have_many(:likes) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    context 'with right atrributes' do
      it 'allows to set png file as an image' do
        user = create(:user)

        subject.attributes = attributes_for(:post)
        subject.user = user

        is_expected.to be_valid
      end
    end

    context 'wrong attributes' do
      it 'does not allow set txt as image' do
        user = create(:user)

        subject.attributes = attributes_for(:post, :with_invalid_image)
        subject.user = user

        is_expected.to be_invalid
      end
    end
  end
end
