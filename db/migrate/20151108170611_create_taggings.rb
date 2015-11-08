class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.belongs_to :tagged, null: false
      t.belongs_to :tag, null: false
    end

    add_index :taggings, [:tagged_id, :tag_id], unique: true
  end
end
