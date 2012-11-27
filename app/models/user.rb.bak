require "digest/sha1"

class User < ActiveRecord::Base
  belongs_to  :person
    
  attr_accessor :password
  attr_accessible :name, :password, :person_id, :id, :other1
  validates_uniqueness_of :name
  validates_presence_of :name, :password
  
  def before_create
    self.hashed_password = User.hash_password(self.password)
  end

  def after_create
    @password = nil
  end

  def before_update
    self.hashed_password = User.hash_password(self.password) if self.password != '******'
  end
  
  def self.login(name, password)
    hashed_password = hash_password(password || "")
    find( :first,
          :conditions => ["name = ? and hashed_password = ?",
          name, hashed_password])
  end

  def try_to_login
    User.login(self.name, self.password)
  end

  private
  def self.hash_password(password)
    Digest::SHA1.hexdigest(password)
  end

end
