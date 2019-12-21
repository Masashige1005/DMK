require 'test_helper'

class CommunityCommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get community_comments_create_url
    assert_response :success
  end

  test "should get destroy" do
    get community_comments_destroy_url
    assert_response :success
  end

end
