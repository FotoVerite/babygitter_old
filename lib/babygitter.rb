require 'grit'
module Babygitter
  # Customizable options
  def self.report_file_path
    @@report_file_path
  end
  
  def self.report_file_path=(report_file_path)
    @@report_file_path = report_file_path
  end
  self.report_file_path = File.join(File.dirname(__FILE__), '../../../../public/babygitter_report.html')

  def self.stylesheet
 @@stylesheet
  end
  def self.stylesheet=(stylesheet)
    @@stylesheet = stylesheet
  end
  self.stylesheet = File.join(File.dirname(__FILE__), '../assets/stylesheets/default.css')

  def self.template
    @@template
  end
  
  def self.template=(template)
    @@template = template
  end
  self.template = File.join(File.dirname(__FILE__), '../assets/templates/default.html.erb')

  def self.additional_links
    @@additional_links
  end
  
  def self.additional_links=(additional_links)
    @@additional_links = additional_links
  end
  self.additional_links = File.join(File.dirname(__FILE__), '../assets/guides/bdd_stack.html.erb')

  def self.instructions
    @@instructions
  end
   
  def self.instructions=(instructions)
    @@instructions = instructions
  end
  self.instructions = File.join(File.dirname(__FILE__), '../assets/guides/display_only.html.erb')
  
  class Babygitter
    
    attr_accessor :total_commits, :branches, :branch_names, :authors, :began, :last_commit, :remote_url, :submodule_list
    
    def initialize(repo)
      @path = repo.path
      @branch_names = get_branch_names(repo)
      @branches = create_branches(repo)
      @authors = get_authors
      @began = first_committed_commit
      @last_commit = last_commited_commit
      @total_commits = get_all_commits_in_repo.size
      @submodule_list = submodule_codes
      @remote_url = get_remote_url(repo)
    end
    
    def get_all_commits_in_repo
      @branches.collect(&:commits).flatten.sort_by { |k| k.authored_date }.reverse
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
    
    def get_remote_url(repo)
      config = Grit::Config.new(repo)
      remote_url = config.fetch('remote.origin.url')
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
      
    def submodule_codes
      `cd #{@path.gsub(/\/.git$/, "")}; git submodule`
    end
    
    def inspect
      %Q{#<Babygitter "#{@branch_names} #{@authors} #{@total_commits} #{@began} #{@id}">}
    end
    
  end
end