require 'test_helper'

class SavedBlogpostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @saved_blogpost = saved_blogposts(:one)
  end

  test "should get index" do
    get saved_blogposts_url
    assert_response :success
  end

  test "should get new" do
    get new_saved_blogpost_url
    assert_response :success
  end

  test "should create saved_blogpost" do
    assert_difference('SavedBlogpost.count') do
      post saved_blogposts_url, params: { saved_blogpost: { blogpost_id: @saved_blogpost.blogpost_id, user_id: @saved_blogpost.user_id } }
    end

    assert_redirected_to saved_blogpost_url(SavedBlogpost.last)
  end

  test "should show saved_blogpost" do
    get saved_blogpost_url(@saved_blogpost)
    assert_response :success
  end

  test "should get edit" do
    get edit_saved_blogpost_url(@saved_blogpost)
    assert_response :success
  end

  test "should update saved_blogpost" do
    patch saved_blogpost_url(@saved_blogpost), params: { saved_blogpost: { blogpost_id: @saved_blogpost.blogpost_id, user_id: @saved_blogpost.user_id } }
    assert_redirected_to saved_blogpost_url(@saved_blogpost)
  end

  test "should destroy saved_blogpost" do
    assert_difference('SavedBlogpost.count', -1) do
      delete saved_blogpost_url(@saved_blogpost)
    end

    assert_redirected_to saved_blogposts_url
  end
end
