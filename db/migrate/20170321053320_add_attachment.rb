class AddAttachment < ActiveRecord::Migration
  def change
  	add_attachment :flashcards, :image
  end

  def up 
  	add_attachment :flashcards, :image
  end 

  def down
  	remove_attachment :flashcards, :image
  end
end
