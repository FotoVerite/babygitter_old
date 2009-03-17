require 'gruff'
module Babygitter
  class ReportGenerator < Babygitter::Repo
  
    def create_histograph_of_commits_by_author_for_branch(branch)
      g = Gruff::Bar.new('800x400') # Define a custom size

      g.sort = false  # Do NOT sort data based on values
      #g.y_axis_increment = 1  # Points shown on the Y axis

      g.legend_font_size = 12 # Legend font size
      g.title_font_size = 22 # Title font size

      g.top_margin = 10 # Empty space on the upper part of the chart
      g.bottom_margin = 20  # Empty space on the lower part of the chart

      g.theme = {   # Declare a custom theme
        :colors => %w(orange silver yellow pink purple green white red #cccccc), # colors can be described on hex values (#0f0f0f)
        :font_color => 'white',
        :marker_color => 'white', # The horizontal lines color
        :background_colors => %w(black grey) # you can use instead: :background_image => ‘some_image.png’
      }

      g.title = 'Commits by Author'

      for author in branch.authors
        g.data("#{author.name}", [author.total_committed])
      end
    
      g.write("#{Babygitter.report_file_path}/babygitter_images/#{branch.name}_commits_by_author.png")
      "<img src =#{Babygitter.report_file_path}/babygitter_images/#{branch.name}_commits_by_author.png />"
    end
    
    def create_stacked_bar_graph_of_commits_by_author_for_branch(branch)
      g = Gruff::StackedBar.new('800x600') # Define a custom size

      g.sort = true  # Do NOT sort data based on values
      g.y_axis_increment = 10  # Points shown on the Y axis

      g.legend_font_size = 12 # Legend font size
      g.title_font_size = 22 # Title font size

      g.top_margin = 10 # Empty space on the upper part of the chart
      g.bottom_margin = 20  # Empty space on the lower part of the chart

      g.theme = {   # Declare a custom theme
        :colors => %w(orange blue yellow pink purple green white red brown), # colors can be described on hex values (#0f0f0f)
        :font_color => 'white',
        :marker_color => 'white', # The horizontal lines color
        :background_colors => %w(gray black) # you can use instead: :background_image => ‘some_image.png’
      }

      g.title = 'Commits for the Last 52 weeks'

      for author in branch.authors
        g.data("#{author.name}", author.create_bar_data_points)
      end
    
      g.write("#{Babygitter.report_file_path}/babygitter_images/#{branch.name}_stacked_bar_graph_by_author.png")
      "<img src =#{Babygitter.report_file_path}/babygitter_images/#{branch.name}_stacked_bar_graph_by_author.png />"
    end
    
    def create_folder_graph(branch, level)
      g = Gruff::Line.new('800x800') # Define a custom size
      g.title = 'Plot of commits by Top Level Folder'
      g.legend_font_size = 10 # Legend font size
      
            
      branch.plot_folder_points(level).each do |key,value|
        key = "program_folder" if key == ""
        g.data(key, value)
      end  
      
      file_path = "#{Babygitter.report_file_path}/babygitter_images/#{branch.name}_level_#{level}_line_graph.png"
      
      g.write(file_path)
      "<img src =#{file_path} />"
    end
    
    def create_bar_graph_of_commits_in_the_last_52_weeks(author)
      g = Gruff::Bar.new('800x300') # Define a custom size

      g.sort = false  # Do NOT sort data based on values
      #g.y_axis_increment = 1  # Points shown on the Y axis

      g.legend_font_size = 12 # Legend font size
      g.title_font_size = 22 # Title font size

      g.top_margin = 10 # Empty space on the upper part of the chart
      g.bottom_margin = 20  # Empty space on the lower part of the chart

      g.theme = {   # Declare a custom theme
        :colors => %w(orange silver yellow pink purple green white red #cccccc), # colors can be described on hex values (#0f0f0f)
        :font_color => 'white',
        :marker_color => 'white', # The horizontal lines color
        :background_colors => %w(black grey) # you can use instead: :background_image => ‘some_image.png’
      }

      g.title = "Commits in the last 52 weeks by #{author.name}"

      g.data("#{author.name}", author.create_bar_data_points)

      @filepath ="#{Babygitter.report_file_path}/babygitter_images/#{author.name.gsub!(/ /, "_")}_commits_last_52_weeks.png"
      g.write(@filepath)
      "<img src =#{@filepath} />"
    end
  end
  
end