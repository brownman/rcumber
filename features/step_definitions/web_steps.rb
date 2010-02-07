def path_to(page_name)
  case page_name
  when /the Dashboard/i
    rcumbers_path
  when /Show Cuke for (.+)/
    "/rcumbers/#{$1}?demos=true"
  when /Edit Cuke for (.+)/
    "/rcumbers/#{$1}/edit"
  else
    raise "Path not found" 
  end
end

Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)      
end

When /^I follow "([^\"]*)"$/ do |link|
  #need to hack in some unstubbing for now
  case link
  when "new feature"
    Rcumber.unstub!(:all) #need this to get arround the stub in cuke_steps really the file should never be saved
                          #and this section to stub the saves and reads instead
  end
  click_link link
end

When /^(?:|I )fill in "([^\"]*)" with "([^\"]*)"$/ do |field, value|
  fill_in(field, :with => value)
end

When /^I fill in "([^\"]*)" with$/ do |field, multiline_value|
  fill_in(field, :with => multiline_value)
end


When /^(?:|I )press "([^\"]*)"$/ do |button|
  click_button(button)
end

Then /^(?:|I )should see "([^\"]*)"$/ do |text|
  response.should contain(text)
end

Then /^I should not see "([^\"]*)"$/ do |text|
  response.should_not contain(text)
end

Then /^I should be on (.+)$/ do |page_name|
  current_path = URI.parse(current_url).select(:path).first
  current_path.should == path_to(page_name).gsub(/\?.*/, '')
end

Then /^the field "([^\"]*)" should contain "([^\"]*)"$/ do |field, value|
  the_field = field_labeled(field) rescue nil
  the_field = field_named(field) if the_field.nil?
  the_field.value.should =~ /#{value}/
end

Then /^I should be able to select "([^\"]*)" from "([^\"]*)"$/ do |option, field|
  select(option, :from => field)
end



