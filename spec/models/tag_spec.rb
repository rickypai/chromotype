require "spec_helper.rb"

describe Tag do

  before :each do
    Asset.delete_all
    Tag.delete_all
    @assets = 3.times.collect { Asset.create! }
    @tag3 = Tag.find_or_create_by_path %w{parent child grandchild}
    @tag2 = @tag3.parent
    @tag1 = @tag2.parent
    @assets[0].add_tag(@tag1)
    @assets[1].add_tag(@tag2)
    @assets[2].add_tag(@tag3)
  end

  it "should find descendant associations" do
    Asset.with_tag_or_descendents(@tag1).should =~ @assets
    Asset.with_tag_or_descendents(@tag2).should =~ @assets.last(2)
    Asset.with_tag_or_descendents(@tag3).should =~ @assets.last(1)
  end
  
  #context :deletion do
  #  before :each do
  #    puts Asset.deleted.to_a
  #    Asset.not_deleted.to_a.should =~ @assets
  #  end
  #
  #  it "should deactivate direct assets" do
  #    @tag3.deactivate_assets
  #    Asset.deleted.to_a.should == [@assets[2]]
  #  end
  #  it "should deactivate indirect assets" do
  #    @tag1.deactivate_assets
  #    Asset.deleted.to_a.should == @assets
  #    Asset.not_deleted.to_a.should be_empty
  #  end
  #end
end
