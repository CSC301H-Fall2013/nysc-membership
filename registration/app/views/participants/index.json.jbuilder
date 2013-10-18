json.array!(@participants) do |participant|
  json.extract! participant, :participantID, :fname, :lname, :phone, :expirydate, :dr_note_date, :password, :email, :birthday, :is_member
  json.url participant_url(participant, format: :json)
end
