---
layout: post
title:  "Asp.net on Linux: Part 2: Editing"
date:   2015-06-26 20:27:00
categories: aspnet linux aspnet_on_linux
series_order: 2
---
{% include posts-aspnet-on-linux.html %}

I'm going to use [Atom](http://www.atom.io) as my editor and I'm assuming you'll do the same.  Atom is a free editor made by GitHub and it's very customizable.  This is the editor that many of the OmniSharp developers use, so it seems like it gets the newest features first.  The previous version of this post used [Sublime Text 3](http://www.sublimetext.com/3) but as of this update, OmniSharp does not seem to work correctly with it.

Atom
------------

Getting Atom is easy:

{% highlight bash %}
$ wget -O atom-amd64.deb https://atom.io/download/deb
$ sudo dpkg -i atom-amd64.deb
$ rm atom-amd64.deb
{% endhighlight bash %}

OmniSharp
---------

[OmniSharp](http://www.omnisharp.net/) brings a lot of conveniences of Visual Studio, like intellisense, to normal text editors.  Atom has a package manager built in, and we'll use that to install OmniSharp.

Open Atom and select the "Edit \| Preferences" menu.  From there, select "Install" and enter "omnisharp-atom" in the search box.  Click the "Install" button and wait for Atom to do its magic!

That's it!
----------

Let's test all this by re-opening the HelloMvc project that we used in the last post.  In Atom, select "File \| Open Folder..." and choose the aspnet-home/samples/1.0.0-beta4/HelloMvc directory from wherever you cloned the aspnet-home git repository.  Open HomeController and within a method body, try typing `string.Is`.  If everything went ok, you should see options pop up.  It may take a moment for the very first suggestions to pop up, but it should be quick after that.

Next time, we'll get our [project started]({% post_url 2015-06-26-aspnet-on-linux-03-project %})!
