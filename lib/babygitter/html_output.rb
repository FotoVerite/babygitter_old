module Babygitter
  
  class ReportGenerator < Babygitter::Repo
    
  def authors_list(array_of_authors)
     case array_of_authors.length
     when 1:
       'Only ' + array_of_authors.first + ' has'
     else
       array_of_authors[0..-2].join(', ') + ' and ' + array_of_authors.last + ' have'
     end
   end
   
   def bl(branches_names)
      case branch_names.length
      when 1:
        "<ul class='page_control'>
            <li><a href=##{branch_names.first.gsub(/ /, "")}>#{branch_names.first}</a></li>
         </ul>"
      else
        string = "<ul class='page_control'>" 
         for name in branch_names[0..-2]
            string += "<li><a href=##{name.gsub(/ /, "")}>#{name}</a></li>\n"
         end
          string += "<li>and <a href=##{branch_names.last.gsub(/ /, "")}>#{branch_names.last}</a></li>
        </ul>"
        string
      end
    end

   def branch_details(branches, remote_url)
      branches.map do |branch|
      "<h2 class='toggler open' id='#{branch.name.gsub(/ /, '')}'>#{branch.name}</h2>\n
      <div class='toggle'>\n
      <div class='image_gallery'>\n" +
      create_histograph_of_commits_by_author_for_branch(branch) + "\n" +
      create_stacked_bar_graph_of_commits_by_author_for_branch(branch) + "\n" +
      folder_graphs(branch, Babygitter.folder_levels) +
      "</div>\n
      <div class='branch_details'>\n" +
      author_links(branch) +
      "<p>Last commit was <tt>#{link_to_github?(branch.latest_commit, remote_url)}</tt> by #{branch.latest_commit.author.name} " +
      "on #{branch.latest_commit.date_time_string}</p>
      <p>They have committed a total of #{pluralize(branch.total_commits, "commit")}</p>
      <h3 class='toggler open'>#{branch.name} commit history</h3>
      <div class='toggle'>
      <ul>
        #{committer_detail(branch.commits, remote_url)}
      </ul>
      </div" +
      author_details(branch.name, branch.authors, remote_url, branch.total_commits) +
      "</div>\n
      </div>"
      end.join("\n")
    end
   
   def author_details(branch_name, authors, remote_branch, total_for_branch)
     authors.map do |author|
        "<h3 id='#{branch_name}_#{author.name.gsub(/ /, "")}' class='toggler open'>#{author.name}</h3>\n
        <div id='#{author.name}' class='toggle'>\n" +
          create_bar_graph_of_commits_in_the_last_52_weeks(author) +
          "<p>#{author.name} first commit for this branch was on #{author.began.date_time_string} <br />
          They have committed #{pluralize(author.total_committed, "commit")} <br />
          #{author.total_committed.to_f / total_for_branch} of the total for the branch<p>
          <ul>
            #{committer_detail(author.commits, remote_url)}
          </ul>\n
        </div>"
      end.join("\n")
   end
   
   def author_links(branch)
      names =  branch.author_names
      case names.length
      when 1:
        "<ul class='page_control'>
            <li>Only <a href=##{branch.name}_#{names.first.gsub(/ /, "")}>#{names.first}</a> has committed to #{branch.name}</li>
         </ul>"
      else
        "<ul class='page_control'>" + 
          names[0..-2].map do |name|
           "<li><a href=##{branch.name}_#{name.gsub(/ /, "")}>#{name}</a>,</li>"
          end.join("\n") +
           "<li><a href=##{branch.name}_#{names.last.gsub(/ /, "")}>#{names.last}</a> have committed to #{branch.name}</li>
        </ul>"
      end
   end
   
   def folder_graphs(branch, levels)
     string = ""
     for level in levels   
       string += create_folder_graph(branch, level) + "\n"
     end
     string
   end
    
   def committer_detail(comments, remote_url)
      comments.map do |c|
        '<li>' + CGI::escapeHTML(c.message) + 
        ' <cite>' + c.author.name + ' ' +
        c.date_time_string + 
        '</cite> ' + link_to_github?(c, remote_url)+ '</li>'
      end.join("\n")
    end
    
    def link_to_github?(commit, remote_url)
      remote_url == "" ? "<tt>#{commit.id_abbrev}</tt>" : 
      "<tt><strong><a href='#{remote_url}/commit/#{commit.id}'>#{commit.id_abbrev}</a></strong></tt>"
    end
    
    def pluralize(count, noun)
      case count
        when 0: "#{count} #{noun.pluralize}"
        when 1: "#{count} #{noun}"
        else "#{count} #{noun.pluralize}"
      end
    end
   
   end
end