require 'rails_helper'

RSpec.describe Blogpost, type: :model do

  let(:leo)             { user(blogposts: 3, saved_blogposts: 3) }
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
      it "matches the given author" do
        expect(leos_blogpost.created_by?(leo)).to eq(true)
      end

      it "doesn't match the given author" do
        raph = user
        expect(leos_blogpost.created_by?(raph)).to eq(false)
      end
    end
  end

  context "model methods" do
    describe "#saved_by?" do
      describe "used on a blogpost saved by raph" do
        it "returns the corresponding saved_blogpost object" do
          raph = user
          saved_blogpost = raph.build_saved_blogpost(leos_blogpost)
          saved_blogpost.save!
          expect(leos_blogpost.saved_by?(raph)).not_to be_nil
          expect(leos_blogpost.saved_by?(raph)).to eq(saved_blogpost)
        end
      end
      describe "used on a blogpost not saved by raph" do
        it "returns nil" do
          raph = user
          expect(leos_blogpost.saved_by?(raph)).to be_nil
        end
      end
    end

    describe "#get_blogposts" do
      describe "as an unfiltered get request" do
        describe "with more blogposts available" do
          it "finds additional blogposts" do
            FactoryBot.create_list(:blogpost, 3)
            _, has_more = Blogpost.get_blogposts(2, user: nil)
            expect(has_more).to eq(true)
          end
        end

        describe "with no additional blogposts available" do
          it "doesn't find additional blogposts" do
            FactoryBot.create_list(:blogpost, 1)
            _, has_more = Blogpost.get_blogposts(2, user: nil)
            expect(has_more).to eq(false)
            FactoryBot.create_list(:blogpost, 1)
            _, has_more = Blogpost.get_blogposts(2, user: nil)
            expect(has_more).to eq(false)
          end
        end

        it "returns leo's and raph's blogposts (2 total)" do
          leo = user(blogposts: 1)
          raph = user(blogposts: 1)
          blogposts, _ = Blogpost.get_blogposts(Blogpost.all.count, user:nil)
          expect(blogposts.count).to eq(2)
          expect(blogposts.where(user_id: leo.id).count).to eq(1)
          expect(blogposts.where(user_id: raph.id).count).to eq(1)
        end
      end

      describe "as a user-specific get request" do
        describe "with more blogposts available" do
          it "finds additional blogposts" do
            leo = user(blogposts: 2)
            _, has_more = Blogpost.get_blogposts(1, user: leo)
            expect(has_more).to eq(true)
          end
        end

        describe "with no additional blogposts available" do
          it "finds no additional blogposts" do
            leo = user(blogposts: 1)
            _, has_more = Blogpost.get_blogposts(2, user: leo)
            expect(has_more).to eq(false)
            FactoryBot.create_list(:blogpost, 1, user: leo)
            _, has_more = Blogpost.get_blogposts(2, user: leo)
            expect(has_more).to eq(false)
          end
        end

        it "returns only leo's blogpost (1 total)" do
          leo = user(blogposts: 1)
          raph = user(blogposts: 2)
          blogposts, has_more =
            Blogpost.get_blogposts(Blogpost.all.count, user: leo)
          expect(blogposts.count).to eq(1)
          expect(blogposts.first.user).to eq(leo)
        end
      end
    end

    describe "#max_blogposts_displayed" do
      describe "without previous requests for additional blogposts" do
        it "returns the default number of blogposts rendered" do
          blogposts_per_request = 10
          previous_more_requests = 0
          expect(
            Blogpost.blogposts_displayed(
              blogposts_per_request,
              more_counter: previous_more_requests + 1
            )
          ).to eq(blogposts_per_request)
        end
      end

      describe "with 2 previous requests for additional blogposts" do
        it "returns 3x the default number of blogposts rendered" do
          blogposts_per_request = 10
          previous_more_requests = 2
          expect(
            Blogpost.blogposts_displayed(
              blogposts_per_request,
              more_counter: previous_more_requests + 1
            )
          ).to eq(3 * blogposts_per_request)
        end
      end
    end

    describe "#limit_blogposts" do
      describe "when rendering the list for the 1st time" do
        it "returns the default number of blogposts rendered" do
          blogposts_per_request = 10
          previous_more_requests = 0
          expect(
            Blogpost.limit_blogposts(
              blogposts_per_request,
              more_counter: previous_more_requests
            )
          ).to eq(blogposts_per_request)
        end
      end

      describe "when requesting additional content for the 1st time" do
        it "returns 2x the default number of blogposts rendered" do
          blogposts_per_request = 10
          previous_more_requests = 0
          expect(
            Blogpost.limit_blogposts(
              blogposts_per_request,
              more_counter: previous_more_requests + 1
            )
          ).to eq(2 * blogposts_per_request)
        end
      end

      describe "when requesting additional content for the 4th time" do
        it "returns 4x the default number of blogposts rendered" do
          blogposts_per_request = 10
          previous_more_requests = 2
          expect(
            Blogpost.limit_blogposts(
              blogposts_per_request,
              more_counter: previous_more_requests + 1
            )
          ).to eq(4 * blogposts_per_request)
        end
      end
    end
  end

  context "validations" do
    describe "#title" do
      it "validates presence" do
        record = Blogpost.new
        record.title = ''
        record.valid?
        expect(record.errors[:title]).to include("can't be blank")

        record.title = 'How to get rich working from home'
        record.valid?
        expect(record.errors[:title]).to_not include("can't be blank")
      end

      it "validates uniqueness" do
        record = Blogpost.new
        record.title = leos_blogpost.title
        record.valid?
        expect(record.errors[:title]).to include("has already been taken")

        record.title = leos_blogpost.title + "!"
        record.valid?
        expect(record.errors[:title]).not_to include("has already been taken")
      end
    end

    describe "#body" do
      it "validates presence" do
        record = Blogpost.new
        record.body = ''
        record.valid?
        expect(record.errors[:body]).to include("can't be blank")

        record.body = "Opinions are subjective!"
        record.valid?
        expect(record.errors[:body]).to_not include("can't be blank")
      end
    end
  end
end
