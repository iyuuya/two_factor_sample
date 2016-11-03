class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.boolean :two_factor_auth, null: false

      t.timestamps
    end
  end
end
