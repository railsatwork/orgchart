class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.string :first
      t.string :last
      t.integer :department_id
      t.integer :reports_to
      t.string :title
      t.integer :external_id
      t.timestamps
    end
  end

  def self.down
    drop_table :employees
  end
end
