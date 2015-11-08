require 'pp'
class Tag < ActiveRecord::Base
  attr_accessor :zero_count

  has_many :taggings
  has_many :taggeds, through: :taggings

  validates :name,
            presence: true

  scope :counted, -> {
    joins { taggings.outer }
      .select('tags.*, COUNT(taggings.id) AS count')
      .group { id }
  }

  scope :on, ->(*tag_ids) {
    joins { taggings.outer }
      .where { taggings.tagged_id.in(Tagged.on(*tag_ids).select { id }) }
  }

  def self.zero_counted
    stored_count = Tagging.counted
    find_each.map { |r| r.zero_count = stored_count[r.id].to_i; r }
  end

  def self.zero_counted_with(*tag_ids)
    sub_query = Tagged.on(*tag_ids).select(:id)
    stored_count = Tagging.on_tagged(sub_query).counted
    find_each.map { |r| r.zero_count = stored_count[r.id].to_i; r }
  end
end
