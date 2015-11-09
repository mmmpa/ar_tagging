class Tagged < ActiveRecord::Base
  has_many :taggings
  has_many :tags, through: :taggings

  validates :name,
            presence: true

  scope :on, ->(*tag_ids) {
    joins { taggings }
      .where { taggings.tag_id.in(tag_ids) }
      .group { id }
      .having { count(id).eq(tag_ids.size) }
  }

  scope :all_on, ->(*tag_ids) {
    joins { taggings }
      .where { taggings.tag_id.in(tag_ids) }
      .uniq
  }
end
