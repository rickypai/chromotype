require "spec_helper.rb"

describe Tag do
  it "should create roots" do
    Tag.create_roots!
    before = Tag.all.dup
    # Creating the seasons root should not add more tags:
    Tag.seasons_root.should_not be_nil
    Tag.all.should =~ before
  end
end
