Given /^(?:|I )am on (.+)$/ do |page_name|
  path = case
    when /the Dashboard/
      rcumbers_path 
  end
  visit path      
end

Then /^(?:|I )should see "([^\"]*)"$/ do |text|
  response.should contain(text)
end