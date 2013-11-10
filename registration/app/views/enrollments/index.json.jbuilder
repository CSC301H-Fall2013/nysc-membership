json.array!(@enrollments) do |enrollment|
  json.extract! enrollment, :participantID, :courseID, :startDate, :waitlist_status, :waitlist_price
  json.url enrollment_url(enrollment, format: :json)
end
