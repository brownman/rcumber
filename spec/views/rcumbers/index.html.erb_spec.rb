require File.join(File.dirname(__FILE__), %w[.. .. spec_helper])

describe "rcumbers/index.html.erb" do
  before(:each) do
    assigns[:rcumbers] = []
  end
  it "should render 'All Features' Tab" do
    render
    response.should contain("All Features")
  end
  it "should render 'Documentation' Tab" do
    render
    response.should contain("Documentation")
  end
  it "renders link to create new" do
    render
    response.should have_selector "a", :content => "create a new cucumber", :href => new_rcumber_path
  end
  context "no cukes exist" do
    it "renders an empty message" do
      render
      response.should contain("You don't have any Cukes in the ./features directory or your project.")
    end
    it "renders a message about the demos" do
      render
      response.should contain("Either create some, or you can look at these Demo Cukes")
    end
    it "renders a link to the demos" do
      render
      response.should have_selector "a", :content => "Demo Cukes", :href => "/rcumbers?demos=true"
    end
  end
  context "demo cukes" do
    it "populates a hidden field to pass on to run many" do
      assigns[:profiles] = []
      assigns[:rcumbers] = [mock(Rcumber, :uid => "some_demo", :name => "Some Demo").as_null_object]
      params[:demos] = "true"
      render
      response.should have_selector "input", :type => "hidden", :name => "demos", :value => "true"
    end
  end
end