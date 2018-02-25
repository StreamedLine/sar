class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|
      t.datetime :date
      t.datetime :time
      t.integer :record_action_number
      t.integer :client_number
      t.float :nis_amount

      t.timestamps
    end
  end
end
