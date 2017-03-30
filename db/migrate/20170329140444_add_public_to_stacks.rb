class AddPublicToStacks < ActiveRecord::Migration
  def change
  	add_column :stacks, :is_public, :integer
  	add_column :stacks, :path_to, :string 
  end
end
