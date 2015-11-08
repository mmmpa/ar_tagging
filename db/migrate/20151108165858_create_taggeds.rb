class CreateTaggeds < ActiveRecord::Migration
  def change
    create_table :taggeds do |t|
      t.string :name, null: false
    end
  end
end
