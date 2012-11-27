# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def get_role(user_id,tgrade)
   role = Person.find(user_id).grade||""
	unless role.blank?
		return (role.downcase.include? "partner" or role.downcase.include? "director" )if tgrade.downcase == 'partner'
		return (role.downcase.include? "manager" )if tgrade.downcase == 'manager'
		return (role.downcase.include? "admin" )if tgrade.downcase == 'admin'
	else
	return false
	end
  end
end
