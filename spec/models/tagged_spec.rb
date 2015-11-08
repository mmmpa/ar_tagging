require 'rails_helper'
require 'benchmark'

RSpec.describe Tagged, type: :model do
  describe 'factory girl' do
    it { expect(create(:tagged, :valid)).to be_a(Tagged) }
  end

  describe 'Speed' do
    before :all do
      num = 10000

      tagged = (1..num).to_a.map do
        create(:tagged, :valid)
      end

      tag =  (1..num).to_a.map do
        create(:tag, :valid)
      end

      num.times do
        begin
          tagged.sample.tags << tag.sample
        rescue => e
          p e
          # タグかぶり対策
        end
      end

      @tags = [tag.sample, tag.sample, tag.sample]
    end

    after :all do
      Tag.delete_all
      Tagged.delete_all
      Tagging.delete_all
    end

    it do
      ActiveRecord::Base.connection.query_cache.clear
      result = Benchmark.realtime do
        p Tag.zero_counted.sample.id
        p Tag.zero_counted_with(*@tags).sample.try(:id)
      end
      p "処理 #{result}s"
    end

    it do
      ActiveRecord::Base.connection.query_cache.clear
      result = Benchmark.realtime do
        p Tag.counted.take.id
        p Tag.on(*@tags).counted.take.try(:id)
      end
      p "処理 #{result}s"
    end
  end

  describe 'Scope' do
    before :all do
      @ed1 = create(:tagged, :valid)
      @ed2 = create(:tagged, :valid)
      @ed3 = create(:tagged, :valid)
      @ed4 = create(:tagged, :valid)
      @ed5 = create(:tagged, :valid)

      @tag1 = create(:tag, :valid)
      @tag2 = create(:tag, :valid)
      @tag3 = create(:tag, :valid)
      @tag4 = create(:tag, :valid)
      @tag5 = create(:tag, :valid)

      @ed1.tags << @tag1

      @ed2.tags << @tag2

      @ed3.tags << @tag1
      @ed3.tags << @tag2

      @ed4.tags << @tag1
      @ed4.tags << @tag3
      @ed4.tags << @tag4

      @ed5.tags << @tag1
      @ed5.tags << @tag2
      @ed5.tags << @tag3
      @ed5.tags << @tag4
    end

    after :all do
      Tag.delete_all
      Tagged.delete_all
      Tagging.delete_all
    end

    describe 'Count Tag' do
      context 'with no filter' do
        it do
          expect(Tag.counted.map(&:count)).to eq([4, 3, 2, 2, 0])
        end
      end

      context 'with tag' do
        it do
          expect(Tag.on(@tag1.id).counted.map(&:count)).to eq([4, 2, 2, 2])
        end

        it do
          expect(Tag.on(@tag2.id).counted.map(&:count)).to eq([2, 3, 1, 1])
        end

        it do
          expect(Tag.on(@tag3.id).counted.map(&:count)).to eq([2, 1, 2, 2])
        end

        it do
          expect(Tag.on(@tag4.id).counted.map(&:count)).to eq([2, 1, 2, 2])
        end

        it do
          expect(Tag.on(@tag5.id).counted.map(&:count)).to eq([])
        end
      end
    end

    describe 'Count Tag with Zero' do
      context 'with tag' do
        it do
          expect(Tag.zero_counted_with(@tag1.id).map(&:zero_count)).to eq([4, 2, 2, 2, 0])
        end

        it do
          expect(Tag.zero_counted_with(@tag2.id).map(&:zero_count)).to eq([2, 3, 1, 1, 0])
        end

        it do
          expect(Tag.zero_counted_with(@tag3.id).map(&:zero_count)).to eq([2, 1, 2, 2, 0])
        end

        it do
          expect(Tag.zero_counted_with(@tag4.id).map(&:zero_count)).to eq([2, 1, 2, 2, 0])
        end

        it do
          expect(Tag.zero_counted_with(@tag5.id).map(&:zero_count)).to eq([0, 0, 0, 0, 0])
        end
      end
    end

    describe 'Pick Tagged by Tag' do
      context 'with tag1' do
        it 'get ed1, ed3, ed4, ed5' do
          expect(Tagged.on(@tag1.id)).to match_array([@ed1, @ed3, @ed4, @ed5])
        end
      end

      context 'with tag2' do
        it 'get ed2, ed3, ed5' do
          expect(Tagged.on(@tag2.id)).to match_array([@ed2, @ed3, @ed5])
        end
      end

      context 'with tag1 and tag2' do
        it 'get ed3, ed5' do
          expect(Tagged.on(@tag1.id, @tag2.id)).to match_array([@ed3, @ed5])
        end
      end

      context 'with tag1 and tag3' do
        it 'get ed4, ed5' do
          expect(Tagged.on(@tag1.id, @tag3.id)).to match_array([@ed4, @ed5])
        end
      end

      context 'with tag1, tag2 and tag3' do
        it 'get ed5' do
          expect(Tagged.on(@tag1.id, @tag2.id, @tag3.id)).to match_array([@ed5])
        end
      end

      context 'with tag1, tag3 and tag4' do
        it 'get ed4, ed5' do
          expect(Tagged.on(@tag1.id, @tag3.id, @tag4.id)).to match_array([@ed4, @ed5])
        end
      end

      context 'with tag1, tag2, tag3 and tag4' do
        it 'get ed5' do
          expect(Tagged.on(@tag1.id, @tag2.id, @tag3.id, @tag4.id)).to match_array([@ed5])
        end
      end
    end
  end
end
