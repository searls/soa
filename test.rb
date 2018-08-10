require "soa"

service "/api/user/:id" do |id|
  puts "finding user #{id}"
end

call_service "/api/user/45" # => puts "finding user 45"

