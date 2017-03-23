class RenameTagTable < ActiveRecord::Migration
  def change
  	rename_table :tags, :user_defined_tags 
  end
end
