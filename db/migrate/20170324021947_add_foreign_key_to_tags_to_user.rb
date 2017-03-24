class AddForeignKeyToTagsToUser < ActiveRecord::Migration
  def change
  	  	add_reference :user_defined_tags, :user, index: true, foreign_key: true
  end
end
