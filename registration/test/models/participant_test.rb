require 'test_helper'

class ParticipantTest < ActiveSupport::TestCase
  
  	#BASIC TESTS
	#search by first name
	def test_search_by_fname
		actual = Participant.search('Elizabeth')
		expected = [participants(:one)]
		assert_equal(actual, expected, "First name did not match")
	end

	#search by last name
	def test_search_by_lname
		actual = Participant.search('Hudson')
		expected = [participants(:one)]
		assert_equal(actual, expected, "Last name did not match")
	end

	#search by phone number
	def test_search_by_phone_number
		actual = Participant.search('4161234567')
		expected = [participants(:one)]
		assert_equal(actual, expected, "Phone number did not match")
	end

	#search by participantID
	def test_search_by_participant_id
		actual = Participant.search('shmoe2')
		expected = [participants(:four)]
		assert_equal(actual, expected, "Participant ID did not match")
	end

	#test no search criteria (all should be returned)
	def test_search_null
		actual = Participant.search('')
		expected = [participants(:four), participants(:three), \
			participants(:two), participants(:one), participants(:five)]
		assert_equal(actual.uniq.sort, expected.uniq.sort, "Not all members \
			were chosen")
	end

	#ADVANCED TESTS
	#search with different case (see if lower case will match upper case)
	def test_search_by_lowercase
		actual = Participant.search('elizabeth')
		expected = [participants(:one)]
		assert_equal(actual, expected, "First name did not match")
	end

	#search by partial string (phone number - last 4 digits)
	def test_search_by_partial_string
		actual = Participant.search('2000')
		expected = [participants(:two)]
		assert_equal(actual.uniq.sort, expected.uniq.sort, "Phone number did not match")
	end

	#search with multiple matches 
	def test_search_with_multiple_matches
		actual = Participant.search('mike')
		expected = [participants(:three), participants(:four)]
		assert_equal(actual.uniq.sort, expected.uniq.sort, "Phone number did not match")
	end

	#NEGATIVE TESTS
	#search by a non-searchable field (ex: ismember)
	def test_search_by_invalid_criteria
		actual = Participant.search('true')
		expected = []
		assert_equal(actual.uniq.sort, expected.uniq.sort, "Phone number did not match")
	end

	#search for entry not in database
	def test_search_not_in_database
		actual = Participant.search('johnnnyyyyyyy')
		expected = []
		assert_equal(actual.uniq.sort, expected.uniq.sort, "Phone number did not match")
	end

end
