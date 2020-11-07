#spec/feature/blogpost_spec.rb

require 'rails_helper'
include Warden::Test::Helpers
Capybara.default_driver = :selenium

RSpec.describe 'Blogpost feature', type: :feature do
  let(:leo)                 { user(blogposts: 1) }
  let(:leos_blogpost) {
    Blogpost.where(user_id: leo.id).order(:created_at).last
  }
  let(:blogposts) {
    {
      bananas: {
        title:  'Did you know that bananas are radioactive?',
        body:   'Each BED (banana equivalent dose) corresponds ' \
                'to 0.1 μSv of ionizing radiation.'
      },
      cherophobia: {
        title:  'What is cherophobia?',
        body:   'Cherophobia is an irrational fear of fun or happiness.'
      },
      kangaroos: {
        title:  'How to stop a kangaroo from hopping',
        body:   "Lift its tail off the ground--then it can't hop."
      },
      coke: {
        title:  'Coca-Cola owns a lot of websites with interesting names...',
        body:   'Coca-Cola owns all website URLs that can be read as ahh, ' \
                'all the way up to 62 h’s!'
      }
    }
  }

  before do
    login_as(leo)
  end

  describe 'post a new blogpost' do
    it 'shows the new blogpost in the feed' do
      visit new_blogpost_path
      fill_in 'Title', with: blogposts[:bananas][:title]
      fill_in 'Body', with: blogposts[:bananas][:body]
      click_on 'Submit'
      visit blogposts_path
      expect(page).to have_content(blogposts[:bananas][:title])
    end
  end

  describe 'click on save_blogpost icon' do
    it 'saves/unsaves the blogpost' do
      visit blogposts_path
      expect(page).to have_content(leos_blogpost.title)
      click_on 'save_blogpost'
      visit saved_blogposts_path
      expect(page).to have_content(leos_blogpost.title)
      click_on 'unsave_blogpost'
      visit saved_blogposts_path
      expect(page).not_to have_content(leos_blogpost.title)
    end
  end

  describe 'delete my blogpost' do
    it 'removes the blogpost from the feed' do
      visit blogposts_path
      click_on 'My posts'
      expect(page).to have_content(leos_blogpost.title)
      accept_confirm do
        click_on 'Delete'
      end
      visit blogposts_path
      click_on 'My posts'
      expect(page).not_to have_content(leos_blogpost.title)
    end
  end
end
