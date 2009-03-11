require File.dirname(__FILE__) + '/spec_helper'
require 'grit'

  @base_repo = Grit::Repo.new(File.join(File.dirname(__FILE__), "/dot_git"), :is_bare => true)
  GIT_REPO =Babygitter::RepoVersionTracker.new(@base_repo)

describe Babygitter do
  
  it "should create a valid url if stored on github" do
    GIT_REPO.remote_url.should  == "http://github.com/schacon/grit/commit"
  end
  
  it "should store all instances of the git branches"
  
  it "should put all local branches" do
    GIT_REPO.branch_names.should == ["nonpack", "test/master", "master", "test/chacon", "testing"] 
  end
  
  it "should store the total number of commits" do
    GIT_REPO.total_commits.should == 531
  end
  
  it "should ascertain when the repo began" do
    GIT_REPO.began.should == "Oct 10 02:18 AM 2007"
  end
  
  it "should get the submodule codes" 
  
  it "should find the latest commit on master" do
    GIT_REPO.main_repo_code.id.should == "ca8a30f5a7f0f163bbe3b6f0abf18a6c83b0687a"
  end
  
  it "should find the last committed commit" do
    GIT_REPO.last_commit.id.should == "ca8a30f5a7f0f163bbe3b6f0abf18a6c83b0687a"
  end
  
  it "should list all authors in an array" do
    GIT_REPO.authors.should == ["Scott Chacon", "Tom Preston-Werner", "Dustin Sallings", "Chris Wanstrath", "Tim Carey-Smith", "Cristi Balan", "Kamal Fariz Mahyuddin", "Wayne Larsen", "rick", "tom"]
  end
  
end

