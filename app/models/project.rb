class Project < ActiveRecord::Base
  # human names
   validates_uniqueness_of :job_code
  ModelName = "Project"
  ColumnNames ={
    :contract_number => "contract_number",
    :job_code => "job_code",
    :description => "description",
    :starting_date => "starting_date",
    :ending_date => "ending_date",
    :estimated_annual_fee => "estimated_annual_fee",
    :contracted_service_fee => "contracted_service_fee",
    :estimated_commision => "estimated_commision",
    :estimated_outsorcing => "estimated_outsorcing",
    :budgeted_service_fee => "budgeted_service_fee",
    :service_PFA => "service_PFA",
    :expense_PFA => "expense_PFA",
    :contracted_expense => "contracted_expense",
    :budgeted_expense => "budgeted_expense",
    :client_name =>"client name"
  }
  
  has_one :deduction
  has_one :initialfee
  
  has_many :outsourcings
  has_many :commissions
  has_many :billings
  has_many :expeases
  has_many :personalcharges
  has_many :ufafees
  
  belongs_to :client
  
  belongs_to :GMU, 
  :class_name => "Dict", 
  :foreign_key => "GMU_id", 
  :conditions => "category ='GMU'" 
  
  belongs_to :status,
  :class_name => "Dict",
  :foreign_key => "status_id",
  :conditions => "category = 'prj_status'"
  
  belongs_to :service_code,
  :class_name => "Dict",
  :foreign_key => "service_id",
  :conditions => "category = 'service_code'"  

  belongs_to :PFA_reason,
  :class_name => "Dict",
  :foreign_key => "PFA_reason_id",
  :conditions => "category = 'PFA_reason'" 
    
  belongs_to :revenue,
  :class_name => "Dict",
  :foreign_key => "revenue_id",
  :conditions => "category = 'revenue_type'"
  
  belongs_to :risk,
  :class_name => "Dict",
  :foreign_key => "risk_id",
  :conditions => "category = 'risk'"  
  
  belongs_to :partner,
  :class_name => "Person",
  :foreign_key => "partner_id"
  
  belongs_to :manager,
  :class_name => "Person",
  :foreign_key => "manager_id"
  
  belongs_to :referring,
  :class_name => "Person",
  :foreign_key => "referring_id"

  belongs_to :billing_partner,
  :class_name => "Person",
  :foreign_key => "billing_partner_id"  
  
  belongs_to :billing_manager,
  :class_name => "Person",
  :foreign_key => "billing_manager_id"   
end
