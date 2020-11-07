require 'rails_helper'

RSpec.describe User, type: :model do
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
  let(:raph)                { user }
  let(:admin)               { create(:user, access_level: 10) }

  context "model methods" do
    describe "#build_blogpost" do
      describe "on an already saved blospost" do
        it "doesn't create another saved blogpost" do
          leos_saved_blogpost
          expect(leo.build_saved_blogpost(leos_blogpost)).to be_nil
          expect {
            leo.build_saved_blogpost(leos_blogpost)
          }.not_to change { SavedBlogpost.all.count }
        end
      end

      describe "on an unsaved blogpost" do
        it "builds a saved blogpost object and returns it" do
          raph.build_saved_blogpost(leos_blogpost).save!
          saved_blogpost = raph.saved_blogposts.first
          expect(saved_blogpost.id).to eq(SavedBlogpost.last.id)
          expect(saved_blogpost.user_id).to eq(raph.id)
          expect(saved_blogpost.blogpost_id).to eq(leos_blogpost.id)
        end
      end
    end

    describe "#is_master_admin?" do
      describe "when used on a regular user" do
        it "returns false" do
          expect(leo.is_master_admin?).to eq(false)
        end
      end

      describe "when used on a master admin" do
        it "returns true" do
          expect(admin.is_master_admin?).to eq(true)
        end
      end
    end
  end

  context "action callbacks" do
    describe "#after_destroy ensure_master_admin_remains" do
      describe "when multiple master admins exist" do
        it "destroys the admin" do
          admin1 = admin
          admin2 = create(:user, access_level: 10)
          expect {
            User.find(admin.id).destroy
          }.to change { User.all.count }.by(-1)
        end
      end

      describe "when one master admin exists" do
        it "raises an exception" do
          admin
          expect {
            User.find(admin.id).destroy
          }.to raise_error("Can't delete the last master admin")
        end
      end
    end
  end

  context "validations" do
    describe "#first_name" do
      it "validates presence" do
        record = User.new
        record.first_name = ''
        record.valid?
        expect(record.errors[:first_name]).to include("can't be blank")

        record.first_name = 'Hercules'
        record.valid?
        expect(record.errors[:first_name]).to_not include("can't be blank")
      end
    end

    describe "#last_name" do
      it "validates presence" do
        record = User.new
        record.last_name = ''
        record.valid?
        expect(record.errors[:last_name]).to include("can't be blank")

        record.last_name = 'None'
        record.valid?
        expect(record.errors[:last_name]).to_not include("can't be blank")
      end
    end
  end
end
