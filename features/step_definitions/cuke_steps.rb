Given /^no cukes exist$/ do
  Rcumber.stub(:all).and_return([])
end

Given /^the cukes "([^\"]*)"$/ do |cukes|
  cukes = cukes.split('/').map { |c| mock(Rcumber, :uid => c, :name => "/#{c}").as_null_object }
  Rcumber.stub(:all).and_return(cukes)
end
