class AddForeignKeyToFlashcardsToUsers < ActiveRecord::Migration
  def change
  	#add_column :flashcards, :user_id, :integer
  	add_reference :flashcards, :user, index: true, foreign_key: true
  end
end
