class Billing < ActiveRecord::Base
  
validates_uniqueness_of :number
  
belongs_to :project
  belongs_to :period
  belongs_to :person
  has_many  :receive_amounts
end
