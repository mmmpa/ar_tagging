class Tagging < ActiveRecord::Base
  belongs_to :tagged
  belongs_to :tag

  validates :tagged, :tag,
            presence: true

  validates :tagged,
            uniqueness: {
              scope: :tag
            }

  scope :on_tagged, ->(tagged_ids) { where { tagged_id.in(tagged_ids) } }
  scope :counted, -> { group { tag_id }.count { tagged } }
end
