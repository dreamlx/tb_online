class Dict < ActiveRecord::Base
   
  has_many :people
  has_many :clients
  has_many :projects
  has_many :overtimes
end
