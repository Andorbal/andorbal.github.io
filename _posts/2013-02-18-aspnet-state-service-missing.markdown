---
layout: post
title:  "ASP.NET State Service missing"
date:   2013-02-18 12:00:00
categories: windows iis aspnet
redirect_from: /blog/2013/2/18/aspnet-state-service-missing/
---
I recently ran into an issue where after deploying a web application to a web server, I got the Yellow Screen of Death.  I opened the site on the server and it turns out that the ASP.NET State Service was not running.  Sigh.  Everything was working before so I figured I'd just need to start the service.  Except, the service was gone!

The server had recently been taken down for a short period of time so that a snapshot could be taken of it.  Is it possible that caused the problem?  I'm not really sure.

I ran across this blog post that suggested just re-registering ASP.NET with IIS would fix the problem.  This server isn't in production yet, so I was fine trying the method.  Luckily, it worked and the service was once again installed.

To re-register ASP.NET, open a command prompt as administrator, change directory to the version of .NET you want to register, and run the following commands:

{% highlight bash %}
aspnet_regiis.exe –u 
aspnet_regiis.exe –i 
aspnet_regiis.exe –c
{% endhighlight %}