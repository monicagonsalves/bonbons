class DropColumnFromFlashcards < ActiveRecord::Migration
  def change
  	remove_column :flashcards, :from_lang
  end
end
