require 'test_helper'

class ParticipantsControllerTest < ActionController::TestCase
  setup do
    @participant = participants(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:participants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create participant" do
    assert_difference('Participant.count') do
      post :create, participant: { birthday: @participant.birthday, dr_note_date: @participant.dr_note_date, email: @participant.email, expirydate: @participant.expirydate, fname: @participant.fname, is_member: @participant.is_member, lname: @participant.lname, participantID: @participant.participantID, password: @participant.password, phone: @participant.phone }
    end

    assert_redirected_to participant_path(assigns(:participant))
  end

  test "should show participant" do
    get :show, id: @participant
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @participant
    assert_response :success
  end

  test "should update participant" do
    patch :update, id: @participant, participant: { birthday: @participant.birthday, dr_note_date: @participant.dr_note_date, email: @participant.email, expirydate: @participant.expirydate, fname: @participant.fname, is_member: @participant.is_member, lname: @participant.lname, participantID: @participant.participantID, password: @participant.password, phone: @participant.phone }
    assert_redirected_to participant_path(assigns(:participant))
  end

  test "should destroy participant" do
    assert_difference('Participant.count', -1) do
      delete :destroy, id: @participant
    end

    assert_redirected_to participants_path
  end
end
