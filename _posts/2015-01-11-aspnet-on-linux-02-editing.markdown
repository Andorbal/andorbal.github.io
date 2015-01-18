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

Next, we'll enable auto-complete in OmniSharp.  OmniSharp's website has [good instructions](https://github.com/OmniSharp/omnisharp-sublime#c-language-specific-settings), but the process is simple.  Open a C# file and open the "Preferences \| Settings - More \| Syntax Specific - User" file.  Add the following settings and save it.

{% highlight javascript %}
{
    "auto_complete": true,
    "auto_complete_selector": "source - comment",
    "auto_complete_triggers": [ {"selector": "source.cs", "characters": ".<"} ],
 }
{% endhighlight %}

Building Through Sublime
------------------------

The Kulture plugin allows you to build your application through Sublime by pressing F7.  Unfortunately, the plugin tries to execute the build script using `sh` which on Linux Mint is linked to `dash`.  This shell doesn't have all the features of `bash`, so the script fails.  I've created a [pull request](https://github.com/OmniSharp/Kulture/pull/20) to address the issue, but if you want to fix it yourself, you need to edit the ASP.NET.sublime-build file in the Kulture package.  To do this, select "Preferences \| Browse Packages" in Sublime Text.  Navigate to the "Kulture" folder and open the ASP.NET.sublime-build file.

{% highlight javascript %}
// Replace this line
"cmd": ["sh", "$packages/Kulture/build.sh"],

// With this
"cmd": ["bash", "$packages/Kulture/build.sh"],
{% endhighlight %}

That's it!
----------

Let's test all this by re-opening the HelloMvc project that we used in the last post.  In Sublime Text, select "File \| Open Folder" and choose the aspnet-home/samples/HelloMvc directory from wherever you cloned the aspnet-home git repository.  Save a project file in the HelloMvc directory by selecting "Project \| Save Project As...".  You can name it whatever you want, but the *.sublime-project file should be in the same directory as the project.json file.

Open the project file you just saved and add a "solution_file" entry.

{% highlight javascript %}
// The project file looks like this by default.
{
  "folders":
  [
    {
      "follow_symlinks": true,
      "path": "."
    }
  ]
}

// Add the "solution_file" entry so the project looks like this.
{
  "folders":
  [
    {
      "follow_symlinks": true,
      "path": "."
    }
  ],
  "solution_file": "."
}
{% endhighlight %}

Save the project file.  Then, select "Tools \| Build System \| ASP.NET" in Sublime Text to enable building the project.  Restart Sublime Text and everything should start working.  Press Ctrl-B to test that the build works.  Next, open HomeController and within a method body, try typing `string.Is`.  If everything went ok, you should see options pop up.  It may take a moment for the very first suggestions to pop up, but it should be quick after that.

Next time, we'll get our [project started]({% post_url 2015-01-17-aspnet-on-linux-03-project %})!