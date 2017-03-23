class RenameTableJoinTable < ActiveRecord::Migration
  def change
  	rename_column :flashcards_tags, :tag_id, :user_defined_tag_id
  	rename_table :flashcards_tags, :flashcards_user_defined_tags
  end
end
