---
layout: post
title:  "Asp.net on Linux: Part 2: Editing"
date:   2015-01-11 21:42:00
categories: aspnet linux aspnet_on_linux
---
{% include posts-aspnet-on-linux.html %}

I'm going to use [Sublime Text 3](http://www.sublimetext.com/3) as my editor and I'm assuming you'll do the same.  Sublime Text is not free, but it's worth paying for.  You can use it as a trial so you can do this walkthrough and decide later if you like it or not.  You're free to use whatever you like, but you'll be on your own getting it set up.

Sublime Text
------------

Getting Sublime Text is easy.  Use the latest build number instead of 3065 if you want the latest and greatest.  If you're on a 64-bit system, replace "i386" in the following command with "amd64".

{% highlight bash %}
$ wget http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3065_i386.deb
$ sudo dpkg -i sublime-text_build-3065_i386.deb
$ rm sublime-text_build-3065_i386.deb
{% endhighlight bash %}

OmniSharp
---------

[OmniSharp](http://www.omnisharp.net/) brings a lot of conveniences of Visual Studio, like intellisense, to normal text editors.  We're going to use the [Sublime Text Package Manager](https://packagecontrol.io/) to install OmniSharp, and you can use it to install many other useful extensions.

To install the package manager, open the Sublime Text console by pressing ``Ctrl+` `` and paste in the following command.

{% highlight bash %}
import urllib.request,os,hashlib; h = '2deb499853c4371624f5a07e27c334aa' + 'bf8c4e67d14fb0525ba4f89698a6d7e1'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); by = urllib.request.urlopen( 'http://packagecontrol.io/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); print('Error validating download (got %s instead of %s), please try manual install' % (dh, h)) if dh != h else open(os.path.join( ipp, pf), 'wb' ).write(by)
{% endhighlight %}

Restart Sublime Text if it asked you to.  We'll need to install the [Kulture](https://packagecontrol.io/packages/Kulture) plugin before we install OmniSharp.  Press `Ctrl-Shift-P` and type `Package Control: Install Package` then hit enter.  Typing `Install` is usually enough, though.  Enter `Kulture` into the package list window to install the package.  When that is finished, install OmniSharp the same way.