class AddColumnToStacks < ActiveRecord::Migration
  def change
  	add_column :stacks, :category, :integer, null: false
  	add_column :stacks, :name, :string
  end
end
