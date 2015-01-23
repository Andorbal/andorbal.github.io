---
layout: post
title:  "Speeding up ASP.NET development"
date:   2013-01-21 12:00:00
categories: windows aspnet visualstudio
redirect_from: /blog/2013/2/1/building-software-for-windows-is-frustrating
---
Getting an SSD makes a huge improvement in working with .NET projects, but there are other things you can do to speed up your development.  I came across this [blog post](http://blog.lavablast.com/post/2010/12/01/Slash-your-ASPNET-compileload-time.aspx) a little over a year ago and it's got some great suggestions on optimizations you can make to improve your development experience.

I especially liked the idea of compiling the Temporary ASP.NET files to a ramdisk.  Once I set that up, I started creating my development databases on the ramdisk as well.  Since I only work with a very small set of data while developing, I was able to get away with a 523MB ramdisk.  Enough to hold the compiled files and my databases, but not so much as to eat up ram needed for other things (like Visual Studio!)

Do any of you have suggestions on how to improve the speed of development using ASP.NET?