class Participant < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

	# Search for all participants that match in the database
	# by fname, lname, participantID, or phone.
	def self.search(search)
	  if search
	    Participant.where(['fname LIKE ? OR lname LIKE ? OR phone LIKE ? OR participantID like ?', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%"])
	  else # When page is initially loaded display no member information.
	    find(:all)
	  end
	end

	# Export all members information as a csv file.
	def self.to_csv
		CSV.generate do |csv|
			csv << column_names
			all.each do |participant|
				csv << participant.attributes.values_at(*column_names)
			end
		end

	end

	# A Participant must present a doctor's note that was written before, and including today
	def dr_note_date_cannot_be_in_the_future
		if dr_note_date.present? && dr_note_date > Date.today
			errors.add(:dr_note_date, "Can't be in the future!")
		end
	end

	# Check if a user is an admin type.
	def admin?
		return self.role
	end

	# Validates 
	def phone_length_between_nine_and_ten
  		errors.add(:phone, "number should be 9 or 10 characters in length") if phone.to_s.length < 9 or phone.to_s.length > 10
	end
	
	#validation
	validates :participantID, :uniqueness => true;
	validates :fname, :presence => { :message => "First Name can't be blank"}
	validates :lname, :presence => { :message => "Last Name can't be blank"}
	validates :phone, :presence => { :message => "Phone Number can't be blank"}
	validates :expirydate, :dr_note_date, :birthday, :presence => { :message => "Date must be in DD-MM-YYYY"}, allow_nil: true
	validate :dr_note_date_cannot_be_in_the_future 
	validate :phone_length_between_nine_and_ten
	
	#validates participantID to be length of
	validates :participantID, length: { is: 8 }

end
