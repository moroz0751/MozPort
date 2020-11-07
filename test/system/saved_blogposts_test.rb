require "application_system_test_case"

class SavedBlogpostsTest < ApplicationSystemTestCase
  setup do
    @saved_blogpost = saved_blogposts(:one)
  end

  test "visiting the index" do
    visit saved_blogposts_url
    assert_selector "h1", text: "Saved Blogposts"
  end

  test "creating a Saved blogpost" do
    visit saved_blogposts_url
    click_on "New Saved Blogpost"

    fill_in "Blogpost", with: @saved_blogpost.blogpost_id
    fill_in "User", with: @saved_blogpost.user_id
    click_on "Create Saved blogpost"

    assert_text "Saved blogpost was successfully created"
    click_on "Back"
  end

  test "updating a Saved blogpost" do
    visit saved_blogposts_url
    click_on "Edit", match: :first

    fill_in "Blogpost", with: @saved_blogpost.blogpost_id
    fill_in "User", with: @saved_blogpost.user_id
    click_on "Update Saved blogpost"

    assert_text "Saved blogpost was successfully updated"
    click_on "Back"
  end

  test "destroying a Saved blogpost" do
    visit saved_blogposts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Saved blogpost was successfully destroyed"
  end
end
