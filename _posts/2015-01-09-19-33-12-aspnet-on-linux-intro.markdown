---
layout: post
title:  "Asp.net on Linux: Introduction"
date:   2015-01-09 19:33:12
categories: aspnet linux aspnet_on_linux
---
{% include posts-aspnet-on-linux.html %}

I've been excited about the next version of Asp.net for awhile now, but after seeing Jay Harris' "[ASP.NET is Coming to an OSX Near You](http://www.codemash.org/session/asp-net-is-coming-to-an-osx-near-you/)" talk at CodeMash 2015, I was inspired to get an Asp.net MVC 6 running on Linux.  In addition, I'm going to set up a full build pipeline using Gulp and deploy to an Azure website.

The application I'll be building is a website that will allow users to track their fitness goals.  At the very least, a user can track their weight, weight lifting exercises, and jogs/runs.  I'm going to assume that the site will be used by millions of people, so I'm going to build load tests and try to keep pages as efficient as possible.

Those are the goals.  Now, lets get the [environment set up]({% post_url 2015-01-09-20-02-00-aspnet-on-linux-01-environment-setup %}).