class Member < ActiveRecord::Base
  attr_accessible :fname, :lname, :honorific, :day, :month, :year, :gender, :address, :apt, :city, :postalcode, :phone, :email
end
