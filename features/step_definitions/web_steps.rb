Given /^(?:|I )am on (.+)$/ do |page_name|
  path = case page_name
    when /the Dashboard/
      rcumbers_path
    when /Show Cuke for (.+)/
      "/rcumbers/#{$1}?demos=true"
    else
      raise "Path not found" 
  end
  visit path      
end

Then /^(?:|I )should see "([^\"]*)"$/ do |text|
  response.should contain(text)
end