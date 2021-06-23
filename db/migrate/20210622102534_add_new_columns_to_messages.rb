class AddNewColumnsToMessages < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :message_type, :string
    add_column :messages, :published, :boolean, default: false
  end
end
