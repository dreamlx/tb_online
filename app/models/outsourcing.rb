class Outsourcing < ActiveRecord::Base
  belongs_to :project
  belongs_to :period
  belongs_to :person  
end
