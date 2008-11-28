##
## This class is designd to wrap around a particular implementation of a cucumber story test.
## It provides a full API to 
##
require 'pathname'
class Rcumber

  attr_accessor :new_filename
  
  ## This class is used to hold the resulting log of a test run
  ## and eventually provide an api around the results of a test run.
  ## for now, I'm just extending an Array
  class RcumberResults < Array
  end
      
  attr_accessor :path, :filename, :raw_content, :name, :preamble, :last_results
  
  VALID_STATES = [nil, :passing, :failing, :pending]
  def state
    @the_state ||= Rails.cache.read("rcumber/#{uid}/state")
    @the_state
  end
  
  def state=(x)
    @the_state = x
    Rails.cache.write("rcumber/#{uid}/state", x.to_s)
  end
  
  def last_results=(results)
    @results = results
    Rails.cache.write("RcumberResults_#{path}", results)
  end
  
  def last_results
    @results ||= Rails.cache.read("RcumberResults_#{path}")
  end
  
  # For now, the UID is the basename w/o extension of the file:  e.g. "../foo.feature" has uid =>"foo"
  # TODO: FIXME: This has the limitation that you need unique cucumber filenames down the entire directory tree...
  attr_reader :uid 

  PATH_PREFIX = RAILS_ROOT + "/features/"
  FEATURE_SUFFIX = ".feature"

  def initialize(path=nil)
    load_from_path(path) unless path.nil?
  end

  ## Use this to 
  def self.create_with_relative_path(path)
    Rcumber.new("#{RAILS_ROOT}/features/#{path}.feature")
  end
  
  def to_s
    uid
  end
  
  def textmate_match(expanded)
    match ||= expanded.match(/Scenario:.*\# (.+):(\d+)/)
    match ||= expanded.match(/(Given|When|Then|And).*\# (\.+):(\d+)/)
    match ||= expanded.match(/(Given|When|Then|And).*\# (.+):(\d+)/)
    match ||= expanded.match(/from (.+):(\d+)/)
    match ||= expanded.match(/^\s*(.+):(\d+):in/)
    match ||= expanded.match(/^(.+):(\d+)\s*$/)
    match
  end
  
  def add_links_to_backtrace(lines)
    lines.collect do |line|
      expanded = line.gsub '#{RAILS_ROOT}', RAILS_ROOT
      if match = textmate_match(expanded)
        m1 = match[3].nil? ? match[1] : match[2]
        m2 = match[3].nil? ? match[2] : match[3]
        file = File.expand_path(m1)
        line_number = m2 if m2
        html = "<a href='txmt://open?url=file://#{file}&line=#{line_number}'>#{line}</a>"
      else
        line
      end
    end
  end

  def last_results_with_textmate_links
    add_links_to_backtrace(self.last_results)
  end
  
  def run
    tempfile = Tempfile.new("rcumber")
    `cucumber #{@path} > #{tempfile.path} 2> #{tempfile.path}`
    self.last_results = RcumberResults.new(File.read(tempfile.path).to_a)  ## TODO Is to_a necessary?
    
    self.state = :passing
    Rails.cache.write("rcumber/#{uid}/state", self.state.to_s)
    self.state = self.parse_test_results
    self.state = :failing unless $?.success? 
  end

  def parse_test_results
    return :failing if self.last_results.to_s =~/(\d+) (steps|scenarios) failed/
    return :pending if self.last_results.to_s =~/(\d) (steps|scenarios) pending/
    return :passing
  end
  
  def save
   File.open(@path, 'w') {|f| f.write(@raw_content) }
  end
  
  def destroy
    File.delete(@path)
  end
  
  ## Might as well make a few available from rcumber if you don't have any cucumber story tests in the project
  def self.demos
    Dir.glob("#{RAILS_ROOT}/vendor/plugins/rcumber/features/**/*#{FEATURE_SUFFIX}").collect { |x| new(x) }
  end
  
  def self.find_demo(the_uid)
    return demos.first
    x = demos.detect {|x| x.uid == the_uid }
    raise "Could not detect cucumber with uid: #{the_uid} in #{demos.inspect}"
  end
  
  def self.all
    Dir.glob("#{PATH_PREFIX}**/*#{FEATURE_SUFFIX}").collect { |x| new(x) }
  end
  
  def self.find(the_id)
    all.detect {|x| x.uid == the_id }
  end

  
  private
  
    def load_from_path(path)
      @path = path
      @uid = File.basename(@path, FEATURE_SUFFIX)
      @raw_content = File.exist?(path) ? File.read(path) : ''
      @preamble = []
      
      next_field = 'name'
      @raw_content.each do |line|
        
        case next_field
        
          when 'name' 
            if @name = (line =~ /Feature: (.*)/ ? $1 : nil)
              next_field = 'preamble'
              break
            end
            
          when 'preamble'
            if line =~ /Scenario:(.*)/
              # next_field = 'scenarios'
              # break
            else
              puts "adding #{line}"
              @preamble << line
            end
            
          else
            raise "unknown next_field #{next_field}"

            
        end
        
      end
    end
    
    def get_feature_name(content)
      content =~ /Feature: (.*)/ ? $1 : nil
    end

    
end
