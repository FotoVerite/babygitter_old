require File.join(File.dirname(__FILE__), '../babygitter')
require File.join(File.dirname(__FILE__), '../babygitter/author')
require File.join(File.dirname(__FILE__), '../babygitter/branch')
require File.join(File.dirname(__FILE__), '../babygitter/report_generator')


namespace :babygitter do
  desc "Reports Git repository metadata to #{Babygitter.report_file_path}"
  task :report do
    Babygitter.repo_path = ENV['repo_path'] if ENV['repo_path']
    Babygitter.folder_levels = ENV['folder_levels'].scan( /\d+/ ).map {|n| n.to_i} if ENV['folder_levels']
    Babygitter.blacklisted_folders = YAML.load(ENV['blacklisted_folders']) if ENV['blacklisted_folders']
    is_bare = false 
    is_bare = true if ENV['is_bare'] == 'true'
    
    FileUtils.mkdir "#{Babygitter.repo_path}/log" unless File.exists?("#{Babygitter.repo_path}/log")
    FileUtils.mkdir  Babygitter.report_file_path unless File.exists?(Babygitter.report_file_path)
    FileUtils.mkdir "#{Babygitter.report_file_path}/babygitter_images" unless File.exists?("#{Babygitter.report_file_path}/babygitter_images")
    FileUtils.cp_r(File.join(File.dirname(__FILE__), '../../../babygitter/assets/image_assets/'), "#{Babygitter.report_file_path}/asset_images")
    Babygitter::ReportGenerator.new(Babygitter.repo_path, :is_bare => is_bare).write_report
    puts "Report written to #{Babygitter.report_file_path}"
  end
end