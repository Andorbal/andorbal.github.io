---
layout: post
title:  "Building software for Windows is frustrating"
date:   2013-02-01 12:00:00
categories: windows
redirect_from: /blog/2013/2/1/building-software-for-windows-is-frustrating
---
I'm not talking about writing software for Windows; that can be easy and even sometimes fun.  The problems arise when you try to use an automated build server, but decide that it shouldn't have Visual Studio on it.  This seems like a pretty reasonable thing to do, and TeamCity and Bamboo (the two build servers I've used on Windows) do their best to make the experience decent.

The problem is that almost nothing you need to build is available without Visual Studio.  You get compilers when you install .NET, but then you'll soon need the Windows SDK.  Except the SDK doesn't install everything you need to build what Visual Studio is able to build, and it sets up incorrect tool paths in the registry to boot.  So you fix those and copy msbuild targets manually into their proper folders on the build server and things start to work.

Until they don't.  I was successfully building web applications, console applications, test suites, and other apps with what I had set up.  Now I just wanted to add a click-once application to the mix.  Of course, the Windows SDK didn't install everything necessary to do that, so all I had to do was copy MORE files over and muck with the registry.  Simple.

I've got to assume that Microsoft wants developers married to Visual Studio and TFS.