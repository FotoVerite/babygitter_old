require 'grit'
require File.join(File.dirname(__FILE__), 'babygitter/commit_addedum')
require File.join(File.dirname(__FILE__), 'babygitter/commit_stats_addedum')
module Babygitter
  
  class << self
    # Customizable options
    attr_accessor :repo_path, :report_file_path, :stylesheet, :template, :additional_links, :instructions, 
    :jquery, :folder_levels, :blacklisted_folders
    
    def blacklisted_folders=(blacklisted_folders)
      raise "must be an array" unless blacklisted_folders.is_a?(Array)
      @blacklisted_folders = blacklisted_folders
    end
    
    def folder_levels=(folder_levels)
      raise "must be an array" unless folder_levels.is_a?(Array)
      @folder_levels = folder_levels
    end
  
  end
  
  self.repo_path = FileUtils.pwd
  self.report_file_path = "#{self.repo_path}" + "/log/babygitter_report"
  self.stylesheet = File.join(File.dirname(__FILE__), '../assets/stylesheets/default.css')
  self.jquery = File.join(File.dirname(__FILE__), '../assets/javascripts/jquery.js')
  self.template = File.join(File.dirname(__FILE__), '../assets/templates/default.html.erb')
  self.additional_links = File.join(File.dirname(__FILE__), '../assets/guides/bdd_stack.html.erb')
  self.instructions = File.join(File.dirname(__FILE__), '../assets/guides/display_only.html.erb')
  self.folder_levels = [1,2]
  self.blacklisted_folders = []

  class Repo
    
    attr_accessor :total_commits, :branches, :branch_names, :authors_names, :began, :lastest_commit, :remote_url,
    :submodule_list, :project_name
    
    def initialize(path, options = {})
      repo = Grit::Repo.new(path, options)
      @path = repo.path
      @branch_names = get_branch_names(repo)
      @branches = create_branches(repo)
      @authors_names = get_authors
      @began = first_committed_commit
      @lastest_commit = last_commited_commit
      @total_commits = get_total_uniq_commits_in_repo
      @config = (Grit::Config.new(repo))
      @submodule_list = submodule_codes
      @remote_url = get_remote_url
      @project_name = get_project_name.capitalize
    end
    
    def get_all_commits_in_repo
      @branches.collect(&:commits).flatten.sort_by { |k| k.authored_date }.reverse
    end
    
    def get_total_uniq_commits_in_repo
      get_all_commits_in_repo.collect(&:id).uniq.size
    end
    
    def last_commited_commit
      get_all_commits_in_repo.first
    end
    
    def first_committed_commit
      get_all_commits_in_repo.last
    end
    
    def get_branch_names(repo)
      repo.heads.collect(&:name)
    end
    
    def create_branches(repo)
      @branch_names.collect {|branch_name| 
      Branch.new(branch_name ,Grit::Commit.find_all(repo, branch_name).sort_by { |k| k.authored_date}.reverse)}
    end
    
    def get_authors
      @branches.collect(&:author_names).flatten.uniq.sort_by { |k| k.downcase }
    end
    
    def get_remote_url
      remote_url = @config.fetch('remote.origin.url').clone
      if remote_url =~ /^git:\/\/github.com/
        remote_url.gsub!(/^git/, "http")
        remote_url.gsub!(/.git$/, "")
      elsif remote_url =~ /^git@github.com/
        remote_url.gsub!(/^git@github.com:/, "http://github.com/")
        remote_url.gsub!(/.git$/, "")
      else
        ""
      end        
    end
    
    def get_master_branch
      master_branch = @config.fetch("branch.master.merge").clone
      master_branch.gsub!(/.*?\//, "")
    end
    
    def get_project_name
      project_name = @config.fetch("remote.origin.url").clone
      project_name.gsub!(/.*?\//, "")
      project_name.gsub!(/.git/, "")
    end
      
    def submodule_codes
      `cd #{@path.gsub(/\/.git$/, "")}; git submodule`
    end
    
    def inspect
      %Q{#<Babygitter::Repo #{@id}">}
    end
    
  end
end