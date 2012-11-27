class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.column :contract_number, :string
      t.column :job_code, :string
      t.column :description, :string
      t.column :starting_date, :date
      t.column :ending_date, :date
      t.column :estimated_annual_fee, :decimal
      t.column :contracted_service_fee, :decimal
      t.column :estimated_commision, :decimal
      t.column :estimated_outsorcing, :decimal
      t.column :budgeted_service_fee, :decimal
      t.column :service_PFA, :integer
      t.column :expense_PFA, :integer
      t.column :contracted_expense, :decimal
      t.column :budgeted_expense, :decimal
    end
  end

  def self.down
    drop_table :projects
  end
end
