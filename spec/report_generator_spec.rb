require File.dirname(__FILE__) + '/spec_helper'
require 'grit'

  GIT_REPO =Babygitter::ReportGenerator.new(File.join(File.dirname(__FILE__), "/dot_git"), :is_bare => true)

describe Babygitter::ReportGenerator do
  
  it "should create a valid url if stored on github" do
    GIT_REPO.remote_url.should  == "http://github.com/schacon/grit"
  end
  
  it "should create a " do
    GIT_REPO.should_receive(:remote_url).and_return("http://somewhere")
    GIT_REPO.remote_url.should  == "http://github.com/schacon/grit"
  end
    
  
  it "should store all instances of the git branches" do
    GIT_REPO.branches.size.should == 5
  end
  
  it "should put all local branches" do
    GIT_REPO.branch_names.should == ["nonpack", "test/master", "master", "test/chacon", "testing"] 
  end
  
  it "should store the total number of commits" do
    GIT_REPO.total_commits.should == 107
  end
  
  it "should ascertain when the repo began" do
    GIT_REPO.began.id.should == "634396b2f541a9f2d58b00be1a07f0c358b999b3"
  end
  
  it "should get the submodule codes"
  
  it "should find the last committed commit" do
    GIT_REPO.lastest_commit.id.should == "ca8a30f5a7f0f163bbe3b6f0abf18a6c83b0687a"
  end
  
  it "should list all authors in an array" do
    GIT_REPO.authors_names.should == ["Chris Wanstrath", "Cristi Balan", "Dustin Sallings", "Kamal Fariz Mahyuddin", "rick", 
      "Scott Chacon", "Tim Carey-Smith", "tom", "Tom Preston-Werner", "Wayne Larsen"]
  end
  
  it "should list the authors of the repo in a readible manner" do 
    GIT_REPO.authors_list(GIT_REPO.authors_names).should == "Chris Wanstrath, Cristi Balan, Dustin Sallings, " + 
"Kamal Fariz Mahyuddin, rick, Scott Chacon, Tim Carey-Smith, tom, Tom Preston-Werner and Wayne Larsen have"
  end
  it "should list the authors commits of the repo in a readible manner" do 
    GIT_REPO.committer_detail(GIT_REPO.branches.first.authors.first.commits[0..3]).should == "<li>timeout code and tests "+
"<cite>Chris Wanstrath Mar 30 11:50 PM 2008</cite> 30e367c</li>
<li>add timeout protection to grit <cite>Chris Wanstrath Mar 30 07:31 PM 2008</cite> 5a09431</li>
<li>support for heads with slashes in them <cite>Chris Wanstrath Mar 29 11:31 PM 2008</cite> e1193f8</li>
<li>Touch up Commit#to_hash\n\n* Use string instead of symbol keys\n* Return parents as 'id' => ID rather than array of id strings <cite>Chris Wanstrath Mar 10 09:10 PM 2008</cite> ad44b88</li>"
  end
end

