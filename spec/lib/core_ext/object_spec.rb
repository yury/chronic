describe Object, :p do
  it "prints things out" do
    old_stdout = $stdout.dup
    
    tempio = StringIO.new
    
    $stdout = tempio
    p "foo"
    $stdout = old_stdout
    
    tempio.string.should == "\"foo\"\n\n"
  end
end