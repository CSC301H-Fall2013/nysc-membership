module EnrollmentsHelper
	def pay_course
		course_fee = Course.find_by(courseID: @enrollment.courseID)
		if_member = Participant.find_by(participantID: @enrollment.participantID)
		earlyBirdTime = course_fee.startDate.months_ago(1)

		if if_member.expirydate > Date.today
			if @enrollment.created_at < Enrollment.get_season #EarlyBird Fee
				link_to("Pay Course", \
				enrollment_path(@enrollment, \
					:enrollment => {:waitlist_price => 0, :waitlist_status => 0}), \
					:method => :put, \
					:confirm => "Please charge $ #{course_fee.earlybirdPrice}")
			else
				#nonearly member price
				link_to("Pay Course", \
				enrollment_path(@enrollment, \
					:enrollment => {:waitlist_price => 0, :waitlist_status => 0}), \
					:method => :put, \
					:confirm => "Please charge $ #{course_fee.memberPrice}")

			end
		else 	#reg non member price
			link_to("Pay Course", \
				enrollment_path(@enrollment, \
					:enrollment => {:waitlist_price => 0, :waitlist_status => 0}), \
					:method => :put, \
					:confirm => "Please charge $ #{course_fee.nonmemberPrice}")

		end

		
		
	end

	

end
