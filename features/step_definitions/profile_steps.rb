Given /^the profiles "([^\"]*)"$/ do |profiles|
  Rcumber.stub!(:profiles).and_return(profiles.split(','))
end
