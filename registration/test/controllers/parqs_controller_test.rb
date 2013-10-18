require 'test_helper'

class ParqsControllerTest < ActionController::TestCase
  setup do
    @parq = parqs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:parqs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create parq" do
    assert_difference('Parq.count') do
      post :create, parq: { ans1: @parq.ans1, ans2: @parq.ans2, ans3: @parq.ans3, ans4: @parq.ans4, ans5: @parq.ans5, ans6: @parq.ans6, ans7: @parq.ans7, courseID: @parq.courseID, disclaimer: @parq.disclaimer, participantID: @parq.participantID, startDate: @parq.startDate }
    end

    assert_redirected_to parq_path(assigns(:parq))
  end

  test "should show parq" do
    get :show, id: @parq
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @parq
    assert_response :success
  end

  test "should update parq" do
    patch :update, id: @parq, parq: { ans1: @parq.ans1, ans2: @parq.ans2, ans3: @parq.ans3, ans4: @parq.ans4, ans5: @parq.ans5, ans6: @parq.ans6, ans7: @parq.ans7, courseID: @parq.courseID, disclaimer: @parq.disclaimer, participantID: @parq.participantID, startDate: @parq.startDate }
    assert_redirected_to parq_path(assigns(:parq))
  end

  test "should destroy parq" do
    assert_difference('Parq.count', -1) do
      delete :destroy, id: @parq
    end

    assert_redirected_to parqs_path
  end
end
