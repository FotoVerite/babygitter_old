require File.join(File.dirname(__FILE__), '../babygitter')
require File.join(File.dirname(__FILE__), '../babygitter/author')
require File.join(File.dirname(__FILE__), '../babygitter/branch')
require File.join(File.dirname(__FILE__), '../babygitter/report_generator')


namespace :babygitter do
  desc "Reports Git repository metadata to #{Babygitter.report_file_path}"
  task :report do
    Dir.mkdir "#{Babygitter.report_file_path}/babygitter_images" unless File.exists?("#{Babygitter.report_file_path}/babygitter_images")
    Babygitter::ReportGenerator.new.write_report
    puts "Report written to #{Babygitter.report_file_path}"
  end
end