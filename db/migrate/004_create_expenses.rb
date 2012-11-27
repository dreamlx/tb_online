class CreateExpenses < ActiveRecord::Migration
  def self.up
    create_table :expenses do |t|
      t.column :created_on, :datetime
      t.column :updated_on, :datetime
      t.column :commission, :decimal
      t.column :outsourcing, :decimal
      t.column :tickets, :decimal
      t.column :courrier, :decimal
      t.column :postage, :decimal
      t.column :stationery, :decimal
      t.column :report_binding, :decimal
      t.column :cash_advance, :decimal
      t.column :payment_on_be_half, :decimal
      t.column :memo, :text
    end
  end

  def self.down
    drop_table :expenses
  end
end
