class CreateCommissions < ActiveRecord::Migration
  def self.up
    create_table :commissions do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :commissions
  end
end
