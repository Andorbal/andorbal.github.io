---
layout: post
title:  "Asp.net on Linux: Part 1: Setting up the environment"
date:   2015-01-09 20:02:00
categories: aspnet linux aspnet_on_linux
---
{% include posts-aspnet-on-linux.html %}

Base system
===========

I'm starting with a default install of [Linux Mint 17.1](http://linuxmint.com/) that's been fully patched.  We'll be using [K Version Manager (KVM)](https://github.com/aspnet/Home/wiki/version-manager) for managing our Asp.net sites and [Gulp](http://gulpjs.com/) to build and run various tasks, so we'll need to make sure we've got all the prerequisites for these to work.  I'm going to assume you're working from a similar starting point, but if you already have some of the required software (like curl, for example), just skip the step that installs it.

Get Node.js
-----------

I prefer to use [NVM](https://github.com/creationix/nvm) to manage node.js, and to get it you should run the following command:

{% highlight bash %}
$ sudo apt-get install curl
$ curl https://raw.githubusercontent.com/creationix/nvm/v0.22.0/install.sh | bash
{% endhighlight %}

Running this will put the following block of code in your .profile file:

{% highlight bash %}
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
{% endhighlight %}

This only gets executed if you run a login shell, which Mint does not do by default.  So I move those two lines out of my .profile and into my .bashrc file.  Since .profile executes .bashrc, this seems pretty safe to do.  Either source your .bashrc file or reopen your terminal window and run:

{% highlight bash %}
$ nvm --version
0.22.0
{% endhighlight %}

You should see a version number if everything installed correctly.  Now we can use it to install a version of node.js:

{% highlight bash %}
$ nvm install v0.10.35
######################################################################## 100.0%
Now using node v0.10.35
$ node --version
v0.10.35
{% endhighlight %}

Running `node --version` just verifies that it is installed and usable.

Get Mono
--------

I'm going to use the [Xamarin packages](http://www.mono-project.com/docs/getting-started/install/linux/#debian-ubuntu-and-derivatives) for Mono because they're the official and most up to date stable releases.

First, we need to add the GPG keys so we can trust the packages from Xamarin's repository:

{% highlight bash %}
$ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
Executing: gpg --ignore-time-conflict --no-options --no-default-keyring --homedir /tmp/tmp.qS3kwGz6rP --no-auto-check-trustdb --trust-model always --keyring /etc/apt/trusted.gpg --primary-keyring /etc/apt/trusted.gpg --keyserver keyserver.ubuntu.com --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
gpg: requesting key D3D831EF from hkp server keyserver.ubuntu.com
gpg: key D3D831EF: public key "Xamarin Public Jenkins (auto-signing) <releng@xamarin.com>" imported
gpg: Total number processed: 1
gpg:               imported: 1  (RSA: 1)
{% endhighlight %}

After adding the keys, we can add the repository to the list of available package repositories and then update the available packages:

{% highlight bash %}
$ sudo echo "deb http://download.mono-project.com/repo/debian wheezy main" | sudo tee /etc/apt/sources.list.d/mono-xamarin.list
deb http://download.mono-project.com/repo/debian wheezy main
$ sudo apt-get update
andorbal@andorbal-VirtualBox ~ $ sudo apt-get update
Get:1 http://download.mono-project.com wheezy InRelease [8,033 B]
-- snip - many other repos --             
Fetched 1,413 kB in 15s (92.2 kB/s)                                            
Reading package lists... Done
{% endhighlight %}

Finally, we can install mono:

{% highlight bash %}
sudo apt-get install mono-complete
{% endhighlight %}

I'm writing this at the [Kalahari](http://www.kalahariresorts.com/ohio) on the last night of [CodeMash](http://www.codemash.org), so this step took awhile over the hotel wifi.  Once it finishes, you should be able to check the version to verify it's installed:

{% highlight bash %}
$ mono --version
Mono JIT compiler version 3.10.0 (tarball Wed Nov  5 13:32:50 UTC 2014)
Copyright (C) 2002-2014 Novell, Inc, Xamarin Inc and Contributors. www.mono-project.com
  TLS:           __thread
  SIGSEGV:       altstack
  Notifications: epoll
  Architecture:  x86
  Disabled:      none
  Misc:          softdebug 
  LLVM:          supported, not enabled.
  GC:            sgen
{% endhighlight %}