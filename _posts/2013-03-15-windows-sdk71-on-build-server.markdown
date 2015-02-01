---
layout: post
title:  "Windows SDK 7.1 on a build server"
date:   2013-03-15 12:00:00
categories: windows sdk build
redirect_from: /blog/2013/3/15/windows-sdk-71-on-a-build-server/
---
Apparently, there is a bug in the Windows 7.1 SDK where registry values aren't set correctly.  This causes the lookup for the location of the v2.0 build tools to fail which means that v4 build tools get used.  This wasn't causing an issue until we started deploying clickonce applications that used a dll that had an XmlSerializers assembly created for it to computers that did not have .NET 4.0 installed.  When the clickonce installer got to the XmlSerializers assembly, it failed to read the manifest because the assembly was for a newer version of .NET than what was installed on the machine.

In our case, fixing the registry as mentioned in the article linked above resulted in an XmlSerializers assembly generated for .NET 2.0, which is what we want.  Since it's a hassle to dig through the registry, I've created two registry files that contain the fix for 64 bit machines.  These files are for the Windows SDK v7.1 only!  If this isn't the version you're developing with, you will most likely break your build tools if you use them.  Also, since these files will modify your registry, do the prudent thing and verify that you understand the changes that they'll make.