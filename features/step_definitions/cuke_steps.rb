def create_cuke(basename, feature_text, demo = true)
  if demo
    @generated_demos ||= []
    path = File.join(RAILS_ROOT, "vendor", "plugins", "rcumber", "features", "#{basename}.feature")
    @generated_demos << path
  else
    @generated_features ||= []
    path = File.join(Rcumber::PATH_PREFIX, "#{basename}.feature")
    @generated_features << path
  end
  example = Rcumber.new
  example.path = path
  example.raw_content = feature_text
  example.save
  return path
end

Given /^no cukes exist$/ do
  Rcumber.stub(:all).and_return([])
end

Given /^the cukes "([^\"]*)"$/ do |cukes|
  cukes = cukes.split('/').map { |c| mock(Rcumber, :uid => c, :name => "/#{c}").as_null_object }
  Rcumber.stub(:all).and_return(cukes)
end

#this creates a cuke in the demos folder (e.g. this plugins feature directory)
#it cleans itself up
Given /^a cuke "([^\"]*)":$/ do |basename, feature_text|
  example = Rcumber.new(create_cuke(basename, feature_text))
  example.stub(:name).and_return(basename) #this is a hack because Rcumber.name does not support anything not features/ right now
  Rcumber.stub(:all).and_return([example])
end

#this creates a cuke in the apps features folder
#it cleans itself up
Given /^I create the cuke "([^\"]*)":$/ do |basename, feature_text|
  example = Rcumber.new(create_cuke(basename, feature_text, true))
  example.stub(:name).and_return(basename)
  Rcumber.stub(:all).and_return([example])
end

Then /^I should see the full feature text for "([^\"]*)"$/ do |basename|
  response.should contain(/#{Rcumber.find_demo(basename).raw_content}/m)
end


Then /^the run log for "([^\"]*)" should contain "([^\"]*)"$/ do |basename, text|
  Rcumber.find(basename).last_results.to_s.should =~ /#{text}/
end





