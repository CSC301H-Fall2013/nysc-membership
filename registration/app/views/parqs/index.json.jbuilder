json.array!(@parqs) do |parq|
  json.extract! parq, :participantID, :courseID, :startDate, :disclaimer, :ans1, :ans2, :ans3, :ans4, :ans5, :ans6, :ans7
  json.url parq_url(parq, format: :json)
end
