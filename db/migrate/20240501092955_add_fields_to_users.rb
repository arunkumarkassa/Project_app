class AddFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :full_name, :string
    add_column :users, :country_code, :string
    add_column :users, :mobile_number, :integer
  end
end
