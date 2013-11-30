module CoursesHelper

	def space_left(course)
		enrolled = Enrollment.where(:courseID => course.courseID).count
		if course.size - enrolled == 0
			return "full"
		end
		return course.size - enrolled
	end

	def class_list(course)

		list = Enrollment.where(:courseID => course.courseID)
		return list.where("waitlist_status > ? ", 0)
		
	end


end
