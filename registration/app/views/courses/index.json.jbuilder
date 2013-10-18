json.array!(@courses) do |course|
  json.extract! course, :courseID, :startDate, :title, :instructor, :description, :intesity, :additional, :duration, :startTime, :endTime, :dayOfWeek, :earlybirdPrice, :memberPrice, :nonmemberPrice, :size
  json.url course_url(course, format: :json)
end
