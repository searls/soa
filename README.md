# SOA

A lot of Ruby and Rails developers can see writing on walls that tells them
small, focused services are the future. Here is a quote from a well-known
Ruby thoughtleader, promoting them on the popular microservice platform
called Twitter dot com:

> Microservices are great for turning method calls in to distributed computing
> problems
 - [Aaron Patterson](https://twitter.com/tenderlove) on [Aug. 9,
   2018](https://twitter.com/tenderlove/status/1027591532847816704)

I've helped teams maintain old, slow, and confusing monolithic applications and
it's taught me one thing: monolithic codebases become more complex over
time. As a result, many companies have decided to build non-monolithic
applications instead (these are called "services"; the better, more modern ones
are called "microservices"). Applications built with services are initially
much more difficult to create and operate, but they also tend to die sooner,
which is the best known way to reduce code complexity.

But how do you write services and microservices in a monolithic language like
Ruby? Up until now, writing services required JavaScript and AWS Lambda. But
because I prefer to write Ruby and sometimes I work offline (AWS can't be
used offline yet), I wrote the SOA gem.

The SOA gem is a drop-in replacement for Ruby's built-in method dispatch system.
You can continue to call legacy methods like you always have alongside new
service invocations registered with the SOA gem. It's the perfect companion for
teams looking to make a more gradual transition to a services architecture
without rewriting their entire years-old system in JavaScript and AWS Lambda.

## Installation

To install SOA, we use the command line command `gem` which communicates with
the RubyGems.org microservice to download the necessary files:

```
gem install soa
```

And then, in your code, you can activate "SOA mode" in your Ruby interpreter
like this

``` ruby
require "soa"
```

[Note that the SOA gem is only tested with C-Ruby. If you want to write services
with JRuby, you'll need to wait for the release of a SOAP gem.]

Once required, the SOA gem will prepare your Ruby runtime to run services and
yes microservices instead using our easy-to-use DSL.

## Usage

To create a new microservice, we use the `service` method and specify a route
path like so:

``` ruby
require "soa"

service "/api/user/:id" do |id|
  User.find(id)
end
```

In order to invoke a SOA microservice, we just `call_service` with the URL. The
service is then looked up from the SOA Service Registry, the params are parsed,
the service is invoked, and the results are returned.

``` ruby
user = call_service "/api/user/45"
puts user.id # => 45
```

It would barely be any easier to just define and call a legacy monolithic Ruby
method!
