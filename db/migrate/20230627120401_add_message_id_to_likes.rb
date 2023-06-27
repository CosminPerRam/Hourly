class AddMessageIdToLikes < ActiveRecord::Migration[7.0]
  def change
    add_column :likes, :message_id, :integer
    add_index :likes, :message_id
  end
end
