class CreateContributions < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.string :img
      t.boolean :online, null: false, default: false
    end
    create_table :friends do |t|
      t.integer :user_id
      t.integer :follower_id
    end
    create_table :activity_logs do |t|
      t.string :user_id
      t.string :date
      t.integer :time
      t.string :detail
    end
  end
end
