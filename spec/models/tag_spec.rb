require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'factory girl' do
    it { expect(create(:tag, :valid)).to be_a(Tag) }
  end
end
