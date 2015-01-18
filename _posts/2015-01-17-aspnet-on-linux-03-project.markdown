---
layout: post
title:  "Asp.net on Linux: Part 3: Creating the project"
date:   2015-01-17 22:33:00
categories: aspnet linux aspnet_on_linux
---
{% include posts-aspnet-on-linux.html %}

We're going to create the project shell today.  We'll add tools to generate the project for us and set up a client library package manager.  We'll also set up the beginning of our build system.  So let's get started!

Yeoman
------

[Yeoman](http://yeoman.io/) is a tool designed to help build client side applications.  There are a large number of generator plugins, but today we'll be using the [aspnet generator](https://www.npmjs.com/package/generator-aspnet) plugin.  Let's get them both now.

To make things simple, lets set our default version of node so that we don't have to keep telling nvm which version to use.  We should have done this when we installed nvm, and I've updated that post to include this step.

{% highlight bash %}
$ nvm alias default v0.10.35
{% endhighlight %}

