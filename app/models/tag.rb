require 'pp'
class Tag < ActiveRecord::Base
  attr_accessor :zero_count

  has_many :taggings
  has_many :taggeds, through: :taggings

  validates :name,
            presence: true

  scope :used, -> {
    joins { taggings.outer }
      .select { ['tags.*', count(taggings.id).as(count)] }
      .group { id }
  }

  scope :on, ->(*tag_ids) {
    joins { taggings.outer }
      .where { taggings.tagged_id.in(Tagged.on(tag_ids).select { id }) }
  }

  class << self
    def zero_used
      stored_count = Tagging.counted
      find_each.map { |r| r.zero_count = stored_count[r.id].to_i; r }
    end

    def zero_used_with(*tag_ids)
      sub_query = Tagged.on(*tag_ids).select(:id)
      stored_count = Tagging.on_tagged(sub_query).counted
      find_each.map { |r| r.zero_count = stored_count[r.id].to_i; r }
    end
  end
end
