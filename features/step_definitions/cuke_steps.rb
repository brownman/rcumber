Given /^no cukes exist$/ do
  Rcumber.stub(:all).and_return([])
end

Given /^the cukes "([^\"]*)"$/ do |cukes|
  cukes = cukes.split('/').map { |c| mock(Rcumber, :uid => c, :name => "/#{c}").as_null_object }
  Rcumber.stub(:all).and_return(cukes)
end

Given /^a cuke "([^\"]*)":$/ do |basename, feature_text|
  path = File.join(RAILS_ROOT, "vendor", "plugins", "rcumber", "features", "#{basename}.feature")
  example = Rcumber.new
  example.path = path
  example.raw_content = feature_text
  example.save
  example = Rcumber.new(path)
  example.stub(:name).and_return(basename) #this is a hack because Rcumber.name does not support anything not features/ right now
  Rcumber.stub(:all).and_return([example])
end

