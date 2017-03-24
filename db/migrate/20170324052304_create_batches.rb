class CreateBatches < ActiveRecord::Migration
  def change
    create_table :batches do |t|
      t.timestamps null: false    
      t.references :user, foreign_key: true
    end

    add_reference :flashcards, :batch, index: true, foreign_key: true
    remove_column :flashcards, :batch_num
	end
end
