class Tagged < ActiveRecord::Base
  has_many :taggings
  has_many :tags, through: :taggings

  validates :name,
            presence: true

  scope :on, ->(*tag_ids) {
    joins { tags.inner }
      .where { tags.id.in(tag_ids) }
      .group { id }.having("COUNT(taggeds.id) = #{tag_ids.size}")
  }
end
