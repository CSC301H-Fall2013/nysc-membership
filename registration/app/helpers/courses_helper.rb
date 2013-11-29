module CoursesHelper

	def space_left(course)
		enrolled = Enrollment.where(:courseID => course.courseID).count
		if course.size - enrolled == 0
			return "full"
		end
		return course.size - enrolled
	end

	def class_list(course)
		return Enrollment.where(:courseID => course.courseID)
	end


end
