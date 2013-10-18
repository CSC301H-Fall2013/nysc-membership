class Participant < ActiveRecord::Base

	#search for all participants with name like
	def self.search(search)
	  if search
	    find(:all, :conditions => ['fname LIKE ? OR lname LIKE ? OR phone LIKE ? OR participantID like ?', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%"])
	  else
	    find(:all)
	  end
	end
end
