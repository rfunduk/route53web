require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Route53::Web do
  it "should be configurable" do
    Route53::Web.config = {
      :access => "123",
      :secret => "abc"
    }
    Route53::Web.config[:access].should == '123'
    Route53::Web.config[:secret].should == 'abc'
  end
end
