---
layout: post
title:  "RSpec Mocks with arbitrary handling and return values"
date:   2013-01-21 12:00:00
categories: ruby rspec test mock
redirect_from: /blog/2013/1/21/rspec-mocks-with-arbitrary-handling-and-return-values
---
Seeing green isn't always a good thing...

I had a suite of rspec tests set up that were all passing, and I felt great about it.  Then I added another test for a method that didn't yet have an implementation and it passed.  Uh oh.  Obviously, select must be broken, so I started digging into RSpec Mock's code to see why it wasn't calling the expectation blocks that I had set up.

I had a test set up that looked like this:

{% highlight ruby linenos %}
it "should work" do
  my_double.should_call :foo do |arg|
    arg.should eq(6)
  end.and_return("bar")
  
  do_thing my_double
end
{% endhighlight %}

That seemed reasonable to me, because the RSpec Mock documentation seemed to suggest that the block was just used for testing the passed argument.  Well, that's apparently not the case.  While trying various "fixes," I had a flash of insight and decided to try actually returning a value from the block, like this:

{% highlight ruby linenos %}
it "should work" do
  my_double.should_call :foo do |arg|
    arg.should eq(6)
    "bar"
  end
  
  do_thing my_double
end
{% endhighlight %}

And suddenly, half my tests were failing!  Normally, I wouldn't be happy about that, but in this case, I can actually tell that the methods are being tested.  And that's a good thing!

Normally, I wouldn't want to mix testing arguments and returning values, but the method that's using the mock was expecting a return value.  While I'm glad I found out what was happening here, I think I'm going to refactor the code so that it can gracefully handle invalid return values.