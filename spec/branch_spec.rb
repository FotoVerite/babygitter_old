require File.dirname(__FILE__) + '/spec_helper'
require 'grit'

  @base_repo = Grit::Repo.new(File.join(File.dirname(__FILE__), "/dot_git"), :is_bare => true)
  GIT_REPO =Babygitter::Babygitter.new(@base_repo)
  BRANCH= GIT_REPO.branches[4]
  
describe Babygitter::Branch do
  
  it "should diplay the author's name" do
    BRANCH.name.should == "testing"
  end
  
  it "should diplay the create author objects" do
    BRANCH.authors.size.should == 9
  end
  
  it "should find the lastest commit" do
    BRANCH.latest_commit.id.should == "2d3acf90f35989df8f262dc50beadc4ee3ae1560"
    BRANCH.latest_commit.date.strftime("%b %d %I:%M %p %Y").should == "Apr 12 10:39 PM 2008"
    
  end
  
  it "should find the when the branch began" do
    BRANCH.began.id.should == "634396b2f541a9f2d58b00be1a07f0c358b999b3"
    BRANCH.began.date.strftime("%b %d %I:%M %p %Y").should == "Oct 10 02:18 AM 2007"
  end
  
  it "should create a data_map_array" do
    BRANCH.create_active_date_array.should == ["40 2007", "40 2007", "40 2007", "40 2007", "40 2007", 
      "40 2007", "40 2007", "40 2007", "40 2007", "40 2007", "40 2007", "40 2007", "40 2007", "40 2007",
      "40 2007", "40 2007", "40 2007", "40 2007", "40 2007", "40 2007", "40 2007", "40 2007", "40 2007", 
      "40 2007", "40 2007", "40 2007", "40 2007"]
  end
  
end