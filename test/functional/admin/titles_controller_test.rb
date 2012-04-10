require 'test_helper'

class Admin::TitlesControllerTest < ActionController::TestCase
  setup do
    @admin_title = admin_titles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_titles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_title" do
    assert_difference('Admin::Title.count') do
      post :create, :admin_title => @admin_title.attributes
    end

    assert_redirected_to admin_title_path(assigns(:admin_title))
  end

  test "should show admin_title" do
    get :show, :id => @admin_title.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @admin_title.to_param
    assert_response :success
  end

  test "should update admin_title" do
    put :update, :id => @admin_title.to_param, :admin_title => @admin_title.attributes
    assert_redirected_to admin_title_path(assigns(:admin_title))
  end

  test "should destroy admin_title" do
    assert_difference('Admin::Title.count', -1) do
      delete :destroy, :id => @admin_title.to_param
    end

    assert_redirected_to admin_titles_path
  end
end
