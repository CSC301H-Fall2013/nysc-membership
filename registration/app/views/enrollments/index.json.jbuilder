json.array!(@enrollments) do |enrollment|
  json.extract! enrollment, :participantID, :courseID, :startDate, :waitlist_status, :price_paid, :price_owed
  json.url enrollment_url(enrollment, format: :json)
end
