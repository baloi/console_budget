Spec::Matchers.define :contain do |element|
  match do |container|
    container.include? element
  end

end

describe Array do
  it "contains the elements" do
    arr = [1, 2, :three, "four"]
    arr.should contain "four"
    arr.should contain 5

  end
end
