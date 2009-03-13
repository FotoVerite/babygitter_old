module Babygitter
  
  class Branch
    
     attr_accessor :name, :author_names, :authors, :commits, :total_commits, :began, :latest_commit

      def initialize(name, commits)
        @name = name
        @commits = commits
        @total_commits = commits.size
        @author_names = get_author_names
        @authors = create_authors
        @began = commits.last
        @latest_commit = commits.first
        @by_week = sorted_commits_by_week
        @mapped_diffs = @by_week.map {|array_of_commits| array_of_commits.map(&:stats).map(&:to_diffstat).flatten }
        @top_level = get_top_level_folders
        @top_and_secondary_level = get_top_and_secondary_level_folders
      end
      
      def get_author_names
        @commits.sort_by {|k| k.author.name.downcase}.collect {|commit| commit.author.name}.uniq
      end
      
      def create_authors
        array = Array.new(@author_names.size).map {|a| a = []}
        sorted_commits = @commits.sort_by {|k| k.date}.reverse
        sorted_commits.map {|commit|
          index = author_names.index(commit.author.name)
          array[index] << commit }
        array.map {|grouped_commits| Author.new(grouped_commits)}
      end
      
      def create_active_date_array
        active_date_array = []
        now = began.date
        i = 0
        weeks_repo_has_been_active = ((latest_commit.date - began.date ) / (60*60*24*7)).ceil
        while i < weeks_repo_has_been_active
          active_date_array << now.strftime("%U %Y")
          now += (60*60*24*7)
          i += 1
        end
        active_date_array
      end
            
      def sorted_commits_by_week
        sort_array = create_active_date_array
        mapped_commits_array = Array.new(create_active_date_array.size).map {|a| a = []}
        for commit in @commits.reverse
          index = sort_array.index(commit.date.strftime("%U %Y"))
          mapped_commits_array[index] << commit
        end
        mapped_commits_array
      end
      
      def get_total_lines_added_by_week
        @mapped_diffs.map {|week| week.map {|c| c.additions - c.deletions}}.map {|a| a.sum}
      end
      
      def get_top_level_folders 
        @mapped_diffs.flatten.map {|diff_stat| 
          diff_stat.filename.scan(/^.*?(?=\/)/) }.flatten.uniq
      end
      
      def get_top_and_secondary_level_folders 
        @top_level + @mapped_diffs.flatten.map {|diff_stat|
           diff_stat.filename.scan(/^.*?\/.*?(?=\/)/) }.flatten.uniq
      end
      
      def create_hash_map(array)
        hash = {}
        array.map {|folder| hash[folder] = 0}
        hash[""] = 0
        hash
      end
      
      def plot_points_for_top_Level_folders
        output = []
        diff_staff_by_week =  @mapped_diffs
          for array_of_diff_staff in diff_staff_by_week
            plot_hash = create_hash_map(@top_level).clone
            for diff in array_of_diff_staff
              key = diff.filename.scan(/^.*?(?=\/)/).to_s
              plot_hash[key] = plot_hash[key] += (diff.additions - diff.deletions)
            end
            output << plot_hash
          end
          output
      end    
      
      def plot_points_for_top_Level_and_secondary_folders
        output = []
        diff_staff_by_week =  @mapped_diffs
          for array_of_diff_staff in diff_staff_by_week
            plot_hash = create_hash_map(@top_and_secondary_level).clone
            for diff in array_of_diff_staff
              if diff.filename.scan(/^.*?\/.*?(?=\/)/).to_s != ""
                key = diff.filename.scan(/^.*?\/.*?(?=\/)/).to_s
              else
                key = diff.filename.scan(/^.*?(?=\/)/).to_s
              end
              plot_hash[key] = plot_hash[key] += (diff.additions - diff.deletions)
            end
            output << plot_hash
          end
          output
      end
    
  end
end