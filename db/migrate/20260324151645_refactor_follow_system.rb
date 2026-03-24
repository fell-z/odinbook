class RefactorFollowSystem < ActiveRecord::Migration[8.1]
  def change
    add_column :follows, :status, :integer, default: 0, null: false

    drop_table :follow_requests do |t|
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :receiver, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
