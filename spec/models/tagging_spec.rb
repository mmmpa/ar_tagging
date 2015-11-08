require 'rails_helper'

RSpec.describe Tagging, type: :model do
  describe 'factory girl' do
    it { expect(create(:tagging, :valid)).to be_a(Tagging) }
  end

  describe 'uniqueness' do
    it do
      tagging = create(:tagging, :valid)

      expect{
        create(:tagging, tag: tagging.tag)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it do
      tagging = create(:tagging, :valid)

      expect{
        create(:tagging, tagged: tagging.tagged)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it do
      tagging = create(:tagging, :valid)

      expect{
        create(:tagging, tag: tagging.tag, tagged: tagging.tagged)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
