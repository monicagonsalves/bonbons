class ChangeColumnToNull < ActiveRecord::Migration
  def change
  	change_column_null :user_defined_tags, :name, false
  end
end
