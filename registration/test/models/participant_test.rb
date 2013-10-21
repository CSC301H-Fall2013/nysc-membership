require 'test_helper'

class ParticipantTest < ActiveSupport::TestCase

	class Participants < ActiveRecord::Base
	  	validates_uniqueness_of :participantID
	  	validates_presence_of :fname, :lname, :is_member, :phone, :birthday
	end
# --------- USER STORY 10 ----------------------------
	
	# Test a valid new member without email saving in the participants database
	def test_valid_new_member_nil_email
		participant = Participant.new(:participantID => "kikiko01", :fname =>"Kiki", :lname =>"Ko", :phone => 4169876256, :expirydate => 2013-12-01, :dr_note_date => 2014-05-23, :password => "mypassword", :email => nil, :birthday => 2000-10-18, :is_member => true)
		assert participant.save, "valid new member was not saved"
	end

	# Test a valid new member with email saving in the participants database
	def test_valid_new_member_with_email
		participant = Participant.new(:participantID => "kikiko01", :fname =>"Kiki", :lname =>"Ko", :phone => 4169876256, :expirydate => 2013-12-01, :dr_note_date => 2014-05-23, :password => "mypassword", :email => "kiki.koko@email.com", :birthday => 2000-10-18, :is_member => true)
		assert participant.save, "valid new member was not saved"
	end

	# failing test of adding a unvalid member into the db ~ ID is not valid
	def test_unvalid_new_member_shouldFail
		participant = Participant.new(:participantID => "kungfu", :fname => "Haro", :lname => "There", :phone => 9999999999, :expirydate => nil, :dr_note_date => nil, :password => nil, :email => nil, :birthday => 1930-04-04, :is_member => true)
		assert participant.save, "unvalid new member was saved"
	end

	# testing null members not being saved into the database
	def test_null_new_member
		participant = Participant.new(:participantID => nil, :fname => nil, :lname => nil, :phone => nil, :expirydate => nil, :dr_note_date => nil, :password => nil, :email => nil, :birthday => nil, :is_member => true)
		assert_not_nil participant.save, "Did save a null nember into database"
 	end

# -----------USER STORY 11---------------------------
	# test the result of renewing a expired membership 
	def test_expired_membership_renewal
		actual = participants(:one)
		Participant.renew(actual)
		expected = Date.today + 1.year
		assert_equal(actual.expirydate, expected, "Membership expiry did not" +
		 " update to a year from today")
	end

	# test the result of renewing a ongoing membership
	def test_ongoing_membership_renewal
		actual = participants(:two)
		Participant.renew(actual)
		expected = Date.parse('2014-12-01')
		assert_equal(actual.expirydate, expected, "Membership expiry did not" +
		 " update to a year from previous expiry")
	end

# -----------USER STORY 22---------------------------
	# BASIC TESTS
	# search by first name
	def test_search_by_fname
		actual = Participant.search('Elizabeth')
		expected = [participants(:one)]
		assert_equal(actual, expected, "First name did not match")
	end

	# search by last name
	def test_search_by_lname
		actual = Participant.search('Hudson')
		expected = [participants(:one)]
		assert_equal(actual, expected, "Last name did not match")
	end

	# search by phone number
	def test_search_by_phone_number
		actual = Participant.search('4161234567')
		expected = [participants(:one)]
		assert_equal(actual, expected, "Phone number did not match")
	end

	# search by participantID
	def test_search_by_participant_id
		actual = Participant.search('shmoe2')
		expected = [participants(:four)]
		assert_equal(actual, expected, "Participant ID did not match")
	end

	# test no search criteria (all should be returned)
	def test_search_null
		actual = Participant.search('')
		expected = [participants(:four), participants(:three), \
			participants(:two), participants(:one), participants(:five)]
		assert_equal(actual.uniq.sort, expected.uniq.sort, "Not all members \
			were chosen")
	end

	# ADVANCED TESTS
	# search with different case (see if lower case will match upper case)
	def test_search_by_lowercase
		actual = Participant.search('elizabeth')
		expected = [participants(:one)]
		assert_equal(actual, expected, "First name did not match")
	end

	# search by partial string (phone number - last 4 digits)
	def test_search_by_partial_string
		actual = Participant.search('2000')
		expected = [participants(:two)]
		assert_equal(actual.uniq.sort, expected.uniq.sort, "Phone number did not match")
	end

	# search with multiple matches 
	def test_search_with_multiple_matches
		actual = Participant.search('mike')
		expected = [participants(:three), participants(:four)]
		assert_equal(actual.uniq.sort, expected.uniq.sort, "Phone number did not match")
	end

	# NEGATIVE TESTS
	# search by a non-searchable field (ex: ismember)
	def test_search_by_invalid_criteria
		actual = Participant.search('true')
		expected = []
		assert_equal(actual.uniq.sort, expected.uniq.sort, "Phone number did not match")
	end

	# search for entry not in database
	def test_search_not_in_database
		actual = Participant.search('johnnnyyyyyyy')
		expected = []
		assert_equal(actual.uniq.sort, expected.uniq.sort, "Phone number did not match")
	end

end


# -----------USER STORY 25---------------------------

	# test the result of updating a user's doctor's note 
	def test_expired_membership_renewal
		actual = participants(:one)
		#to be implemented:
		#Participant.addnote(actual)
		expected = Date.today
		assert_equal(actual.expirydate, expected, "Membership expiry did not" +
		 " update to a year from today")
	end