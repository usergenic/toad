def parse_attrs(sentence)
  Hash[sentence.scan(/([\w ]+) "([^"]+)"(?: and )?/)]
end

def parse_type(name)
  const_name = name.split(" ").map(&:capitalize).join("")
  (class << self; self end).const_get(const_name)
end

def find_item_by_name(name)
  User.where(username: name).first || Project.where(title: name).first
end

Given("there are no users") { User.count.should == 0 }

Given(/^there is an? ([^"]*) with (.*)$/) do |type, attrs|
  parse_type(type).create(parse_attrs(attrs)).should be_persisted
end

Then(/^there should be a ([^"]*) with (.*)$/) do |type, attrs|
  puts "#{type} = #{parse_type(type).count}"
  parse_type(type).where(parse_attrs(attrs)).count.should == 1
end



