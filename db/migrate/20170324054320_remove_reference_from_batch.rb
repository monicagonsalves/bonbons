class RemoveReferenceFromBatch < ActiveRecord::Migration
  def change
  	remove_reference :batches, :user, index: true, foreign_key: true
  end
end
