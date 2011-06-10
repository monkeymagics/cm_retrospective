$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'fake_web'
require 'cm_retrospective'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|

end

# PivotalTracker::Project
project_xml = nil
File.open(File.expand_path(File.dirname(__FILE__) + '/fixtures/project.xml')) do |f|
  project_xml = f.read
end
FakeWeb.register_uri(:get, "http://www.pivotaltracker.com/services/v3/projects/291045",
  :headers => { 'X-TrackerToken' => "xxxxx", 'Content-Type' => 'application/xml' },
  :body => project_xml)

# PivotalTracker::Iteration
iterations_xml = nil
File.open(File.expand_path(File.dirname(__FILE__) + '/fixtures/iterations.xml')) do |f|
  iterations_xml = f.read
end
FakeWeb.register_uri(:get, "http://www.pivotaltracker.com/services/v3/projects/291045/iterations/current",
  :headers => { 'X-TrackerToken' => "xxxxx", 'Content-Type' => 'application/xml' },
  :body => iterations_xml)

# PivotalTracker::Story
stories_xml = nil
File.open(File.expand_path(File.dirname(__FILE__) + '/fixtures/stories.xml')) do |f|
  stories_xml = f.read
    end
FakeWeb.register_uri(:get, "http://www.pivotaltracker.com/services/v3/projects/291045/stories",
  :headers => { 'X-TrackerToken' => "xxxxx", 'Content-Type' => 'application/xml' },
  :body => stories_xml)

# PivotalTracker::Note
 notes_4460038_xml = nil
 File.open(File.expand_path(File.dirname(__FILE__) + '/fixtures/notes_4460038.xml')) do |f|
   notes_4460038_xml = f.read
 end
 FakeWeb.register_uri(:get, "http://www.pivotaltracker.com/services/v3/projects/291045/stories/4460038/notes",
   :headers => { 'X-TrackerToken' => "xxxxx", 'Content-Type' => 'application/xml' },
   :body => notes_4460038_xml)

 notes_4460039_xml = nil
 File.open(File.expand_path(File.dirname(__FILE__) + '/fixtures/notes_4460039.xml')) do |f|
   notes_4460039_xml = f.read
 end
 FakeWeb.register_uri(:get, "http://www.pivotaltracker.com/services/v3/projects/291045/stories/4460039/notes",
   :headers => { 'X-TrackerToken' => "xxxxx", 'Content-Type' => 'application/xml' },
   :body => notes_4460038_xml)
