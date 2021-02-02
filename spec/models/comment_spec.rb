require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { create(:comment) }
  subject { comment}

  describe 'assosiations' do
    it { is_expected.to belong_to(:post) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:comment) }
    it { is_expected.to validate_length_of(:comment).is_at_most(200) }  
  end
end
