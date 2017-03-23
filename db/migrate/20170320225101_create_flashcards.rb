class CreateFlashcards < ActiveRecord::Migration
	def change
	    create_table :english_translations do |t|
	      t.string :from_lang, null: false 
	      t.string :translation, null: false 
	      t.string :orig_word, null: false 
	      t.timestamps null: false
	    end

	  	# A stack has many flashcards, and a flashcard
	  	# belongs to a stack 
	  	create_table :stacks do |t| 
	  		t.timestamps null: false 
	  	end 

	    create_table :language_pairs do |t|
	      t.string :code, limit: 7, index: true, null: false
	      t.string :from_lang, null: false 
	      t.string :to_lang, null: false 
	      t.timestamps null: false
	    end

	  	# A single flashcard can be associated with many tags, 
	  	# and a single tag can be associated with many 
	  	# flashcards
	  	create_table :tags do |t| 
	  		t.string :name, null: false, unique: true, index: true 
	  		t.timestamps null: false 
	  	end 

	  	create_join_table :flashcards, :tags do |t| 
	  		t.index :flashcard_id
	  		t.index :tag_id
	  	end

	  	create_join_table :flashcards, :stacks do |t| 
	  		t.index :flashcard_id
	  		t.index :stack_id 
	  	end 

	    create_table :flashcards do |t|
	      t.string :translation, null: false
	      t.string :orig_word, null: false
	      t.integer :from_lang, null: false
	      t.string :gender, null: false, limit: 1 
	      t.timestamps null: false
	      t.references :language_pair, foreign_key: true 
	    end

	    add_column :flashcards_tags, :id, :primary_key
	    add_column :flashcards_stacks, :id, :primary_key
	end

  def up
  	add_attachment :flashcards, :image
  	add_attachment :flashcards, :audio
  end

  def down 
  	remove_attachment :flashcards, :image
  	remove_attachment :flashcards, :audio
  end
end
