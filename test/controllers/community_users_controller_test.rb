require 'test_helper'

class CommunityUsersControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get community_users_create_url
    assert_response :success
  end

  test "should get destroy" do
    get community_users_destroy_url
    assert_response :success
  end

end
