class CreateClient < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.string :client_name
      t.string :branch_name
      t.integer :code
      t.string  :subdomain
      
      t.timestamps null: false
    end
  end
end
