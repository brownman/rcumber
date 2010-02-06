require File.join(File.dirname(__FILE__), %w[.. .. spec_helper])

describe "rcumbers/new.html.erb" do
  before(:each) do
    assigns[:rcumber] = mock(Rcumber, :path => nil, :name => nil)
  end
  it "renders a form with a create button" do
    render
    response.should have_selector "form" do |form|
      form.should have_selector "input", :type => "submit", :value => "Create"
    end
  end
  it "renders a path field" do
    render
    response.should have_selector "form" do |form|
      form.should have_selector "label", :for => "rcumber_path", :content => "Enter the base filename"
      form.should have_selector "input", :name => "rcumber[path]", :type => "text"
    end
  end
  it "renders a name field" do
    render
    response.should have_selector "form"  do |form|
      form.should have_selector "label", :for => "rcumber_name", :content => "Enter the Feature name:"
      form.should have_selector "input", :name => "rcumber[name]", :type => "text"
    end
    
  end
end