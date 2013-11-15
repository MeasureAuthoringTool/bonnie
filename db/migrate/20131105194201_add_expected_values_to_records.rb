class AddExpectedValuesToRecords < ActiveRecord::Migration
  def change
  	add_column :expected_values, :string
  end
end
