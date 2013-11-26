module EnrollmentsHelper
	def pay_course
		course_fee = Course.find_by(courseID: @enrollment.courseID)
		if_member = Participant.find_by(participantID: @enrollment.participantID)
		earlyBirdTime = course_fee.startDate.months_ago(1)

		if if_member.expirydate > Date.today
			if @enrollment.created_at < Enrollment.get_season #EarlyBird Fee
				link_to("Pay Course Fee Now!", \
				enrollment_path(@enrollment, \
					:enrollment => {:price_owed => 0, :price_paid => course_fee.earlybirdPrice, :waitlist_status => 0}), \
					:method => :put, \
					:confirm => "Please charge $ #{course_fee.earlybirdPrice}")
			else
				#nonearly member price
				link_to("Pay Course Fee Now!", \
				enrollment_path(@enrollment, \
					:enrollment => {:price_owed => 0, :price_paid => course_fee.memberPrice, :waitlist_status => 0}), \
					:method => :put, \
					:confirm => "Please charge $ #{course_fee.memberPrice}")

			end
		else 	#reg non member price
			link_to("Pay Course Fee Now!", \
				enrollment_path(@enrollment, \
					:enrollment => {:price_owed => 0, :price_paid => course_fee.nonmemberPrice, :waitlist_status => 0}), \
					:method => :put, \
					:confirm => "Please charge $ #{course_fee.nonmemberPrice}")

		end		
	end

	def if_member(member)
		if_member = Participant.find_by(participantID: member)
		if if_member != nil
			if if_member.expirydate > Date.today
				return true
			else
				return false
			end
		end
	end

	def course_fee(member, course)
		if_course = Course.find_by(courseID: course)
		if if_course != nil
			earlyBirdTime = if_course.startDate.months_ago(1)
			if member
			 	if Date.today >= earlyBirdTime && Date.today < if_course.startDate
			 		return if_course.earlybirdPrice
				else
			 		return if_course.memberPrice
			 	end
			else
				return if_course.nonmemberPrice
			 end
		end
	end



	

end
