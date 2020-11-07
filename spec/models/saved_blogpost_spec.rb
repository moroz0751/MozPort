require 'rails_helper'

RSpec.describe SavedBlogpost, type: :model do
  let(:leo)           { user(blogposts: 3, saved_blogposts: 3) }
  let(:leos_blogpost)   {
    blogpost_params = {
      title: "Cheese is evil",
      body: "It kills 260 people per year."
    }
    blogpost = leo.blogposts.build(blogpost_params)
    blogpost.save!
    blogpost
  }
  let(:leos_saved_blogpost)   {
    saved_blogpost = leo.build_saved_blogpost(leos_blogpost)
    saved_blogpost.save!
    saved_blogpost
  }

  context "RelationsHelper concern" do
    describe "#created_by?" do
      it "matches the given creator" do
        expect(leos_saved_blogpost.created_by?(leo)).to eq(true)
      end

      it "doesn't match the given creator" do
        raph = user
        expect(leos_saved_blogpost.created_by?(raph)).to eq(false)
      end
    end
  end

  context "model methods" do
    describe "#get_saved_blogposts" do
      describe "with more saved blogposts available" do
        it "finds additional saved blogposts" do
          leo = user(saved_blogposts: 3)
          _, has_more = SavedBlogpost.get_saved_blogposts(2, user: leo)
          expect(has_more).to eq(true)
        end
      end

      describe "with no additional blogposts available" do
        it "doesn't find additional blogposts" do
          leo = user(saved_blogposts: 1)
          _, has_more = SavedBlogpost.get_saved_blogposts(2, user: leo)
          expect(has_more).to eq(false)
          FactoryBot.create_list(:saved_blogpost, 1, user: leo )
          _, has_more = SavedBlogpost.get_saved_blogposts(2, user: leo)
          expect(has_more).to eq(false)
        end
      end

      it "returns leo's and raph's blogposts (2 total)" do
        leo = user(blogposts: 1)
        raph = user(blogposts: 1)
        blogposts, _ = Blogpost.get_blogposts(Blogpost.all.count, user: nil)
        expect(blogposts.count).to eq(2)
        expect(blogposts.where(user_id: leo.id).count).to eq(1)
        expect(blogposts.where(user_id: raph.id).count).to eq(1)
      end
    end
  end

  context "validations" do
    describe "#user_id" do
      it "validates presence" do
        record = SavedBlogpost.new
        record.user_id = ''
        record.valid?
        expect(record.errors[:user_id]).to include("can't be blank")

        record.user_id = leo.id
        record.valid?
        expect(record.errors[:user_id]).to_not include("can't be blank")
      end
    end

    describe "#blogpost_id" do
      it "validates presence" do
        record = SavedBlogpost.new
        record.blogpost_id = ''
        record.valid?
        expect(record.errors[:blogpost_id]).to include("can't be blank")

        record.blogpost_id = leos_blogpost.id
        record.valid?
        expect(record.errors[:blogpost_id]).to_not include("can't be blank")
      end
    end
  end
end
