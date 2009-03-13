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
  
  it "should diplay the total number of commits" do
     BRANCH.total_commits.should == 105
  end
   
  it "should find the lastest commit" do
    BRANCH.latest_commit.id.should=="2d3acf90f35989df8f262dc50beadc4ee3ae1560"
    BRANCH.latest_commit.date.strftime("%b %d %I:%M %p %Y").should == "Apr 12 10:39 PM 2008"
    
  end
  
  it "should find the when the branch began" do
    BRANCH.began.id.should == "634396b2f541a9f2d58b00be1a07f0c358b999b3"
    BRANCH.began.date.strftime("%b %d %I:%M %p %Y").should == "Oct 10 02:18 AM 2007"
  end
  
  it "should create a data_map_array" do
    BRANCH.create_active_date_array.should == ["40 2007", "41 2007", "42 2007", "43 2007", 
      "44 2007", "45 2007", "46 2007", "47 2007", "48 2007", "49 2007", "50 2007", "51 2007",
      "00 2008", "01 2008", "02 2008", "03 2008", "04 2008", "05 2008", "06 2008", "07 2008", 
      "08 2008", "09 2008", "10 2008", "11 2008", "12 2008", "13 2008", "14 2008"]
  end
  
  it "should map the commits to an array by week" do 
    BRANCH.sorted_commits_by_week.first.first.should == BRANCH.began
    BRANCH.sorted_commits_by_week.first.size.should == 22
    BRANCH.sorted_commits_by_week.flatten.size.should == BRANCH.total_commits
  end
  
  it "should map total lines commited per week" do
    BRANCH.get_total_lines_added_by_week.should == [998, 324, 287, 716, 0, 0, 0, 0,
    0, 0, 0, 68, 0, 82, 291, 12, 18, 702, 358, 1293, 9, 111, 38, 0, 8, 92, 5]
  end
  
  it "should find the top level folders for the project" do 
    BRANCH.get_top_level_folders.should == ["lib", "test", "bin"]
  end
  
  it "should create an array map for plotting lines commit by folder" do
    BRANCH.create_points_map_for_top_level_folders.should == {""=> 0, "lib"=> 0, "bin"=> 0, "test"=> 0}
  end
  
  it "should create an array hashes for plotting by top level folder" do
   @plotted_points = BRANCH.plot_points_for_folders
   @plotted_points.should == [{""=>79, "lib"=>583, "bin"=>0, "test"=>336}, 
     {""=>6, "lib"=>127, "bin"=>0, "test"=>191}, {""=>181, "lib"=>54, "bin"=>0, "test"=>52}, 
     {""=>0, "lib"=>26, "bin"=>0, "test"=>690}, {""=>0, "lib"=>0, "bin"=>0, "test"=>0}, 
     {""=>0, "lib"=>0, "bin"=>0, "test"=>0}, {""=>0, "lib"=>0, "bin"=>0, "test"=>0},
     {""=>0, "lib"=>0, "bin"=>0, "test"=>0}, {""=>0, "lib"=>0, "bin"=>0, "test"=>0}, 
     {""=>0, "lib"=>0, "bin"=>0, "test"=>0}, {""=>0, "lib"=>0, "bin"=>0, "test"=>0}, 
     {""=>0, "lib"=>46, "bin"=>0, "test"=>22}, {""=>0, "lib"=>0, "bin"=>0, "test"=>0},
     {""=>8, "lib"=>38, "bin"=>0, "test"=>36}, {""=>10, "lib"=>34, "bin"=>0, "test"=>247},
     {""=>0, "lib"=>12, "bin"=>0, "test"=>0}, {""=>0, "lib"=>1, "bin"=>0, "test"=>17},
     {""=>0, "lib"=>21, "bin"=>0, "test"=>681}, {""=>0, "lib"=>132, "bin"=>0, "test"=>226},
     {""=>0, "lib"=>43, "bin"=>0, "test"=>1250}, {""=>0, "lib"=>6, "bin"=>0, "test"=>3}, 
     {""=>1, "lib"=>46, "bin"=>0, "test"=>64}, {""=>0, "lib"=>19, "bin"=>0, "test"=>19},
     {""=>0, "lib"=>0, "bin"=>0, "test"=>0}, {""=>1, "lib"=>2, "bin"=>0, "test"=>5}, 
     {""=>0, "lib"=>61, "bin"=>0, "test"=>31}, {""=>0, "lib"=>5, "bin"=>0, "test"=>0}]
   @plotted_points.size.should == BRANCH.create_active_date_array.size
  end
      
end