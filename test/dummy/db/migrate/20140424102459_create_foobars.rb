class CreateFoobars < ActiveRecord::Migration
  def change
    create_table :foobars do |t|
      t.integer :test_seconds

      t.timestamps
    end
  end
end
