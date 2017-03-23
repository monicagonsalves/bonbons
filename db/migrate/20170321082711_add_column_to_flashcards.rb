class AddColumnToFlashcards < ActiveRecord::Migration
  def change
  	add_column :flashcards, :batch_num, :integer, null: false
  end
end
