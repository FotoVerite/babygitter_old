module Babygitter
  
  class ReportGenerator < Babygitter::Repo
    
  def authors_list(array_of_authors)
     case array_of_authors.length
     when 1
       'Only ' + array_of_authors.first + ' has'
     else
       array_of_authors[0..-2].join(', ') + ' and ' + array_of_authors.last + ' have'
     end
   end

   def branch_details(branches, remote_url)
      branches.map do |branch|
       "<div>
      <h2>#{branch.name}</h2>\n" +
      create_histograph_of_commits_by_author_for_branch(branch) +
      create_stacked_bar_graph_of_commits_by_author_for_branch(branch) +
      folder_graphs(branch, Babygitter.folder_levels) +
      "<p>Last commit was done <tt>#{link_to_github?(branch.latest_commit, remote_url)}</tt> by #{branch.latest_commit.author.name} " +
      "on #{branch.latest_commit.date_time_string}
      <ul>
        #{committer_detail(branch.commits, remote_url)}
      </ul>" +
      author_details(branch.authors, remote_url, branch.total_commits)
      end.join("</div>")
    end
   
   def author_details(authors, remote_branch, total_for_branch)
     authors.map do |author|
      "<div>
        <h3>#{author.name}</h3>" +
        create_bar_graph_of_commits_in_the_last_52_weeks(author) +
        "<p>#{author.name} first commit for this branch was on #{author.began.date_time_string} <br />
        They have committed #{pluralize(author.total_committed, "commit")} <br />
        #{author.total_committed.to_f / total_for_branch} of the total for the branch<p>
        <ul>
          #{committer_detail(author.commits, remote_url)}
        </ul>"
      end.join("</div")
   end
   
   def folder_graphs(branch, levels)
     string = ""
     i = 1
      while i <= levels
        string += create_folder_graph(branch, i) + "\n"
        i += 1
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
      remote_url == "" ? "<tt><#{commit.id_abbrev}</tt>" : 
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