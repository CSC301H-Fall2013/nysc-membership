module ParticipantsHelper

	# presents a renew membership link based on current membership expiration status
	def renew_link
		if (@participant.expirydate >= Date.today)
			# membership has not yet expired
			link_to("Renew Membership", \
				participant_path(@participant, \
					:participant => {:expirydate => @participant.expirydate + 1.year}), \
					:method => :put, \
					:confirm => "You are renewing a membership, please charge member $40.")
		else
			# membership has expired already
			link_to("Renew Expired Membership", \
				participant_path(@participant, \
					:participant => {:expirydate => Date.today + 1.year}), \
					:method => :put, \
					:confirm => "You are renewing an EXPIRED membership, please charge member $45.")
		end
	end
	
end
