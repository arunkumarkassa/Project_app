class AddTermsAndConditions < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :terms_and_conditions, :boolean
  end
end
