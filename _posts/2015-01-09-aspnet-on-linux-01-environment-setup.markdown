---
layout: post
title:  "Asp.net on Linux: Part 1: Setting up the environment"
date:   2015-01-09 20:02:00
categories: aspnet linux aspnet_on_linux
hide: true
---
{% include posts-aspnet-on-linux.html %}

UPDATE
======
There is an updated version of this guide [here]({% post_url 2015-06-26-aspnet-on-linux-01-environment-setup %}).  This version exists for historical reasons only and should no longer be used.

Base system
===========

I'm starting with a default install of [Linux Mint 17.1](http://linuxmint.com/) that's been fully patched.  We'll be using [K Version Manager (KVM)](https://github.com/aspnet/Home/wiki/version-manager) for managing our Asp.net sites and [Gulp](http://gulpjs.com/) to build and run various tasks, so we'll need to make sure we've got all the prerequisites for these to work.  I'm going to assume you're working from a similar starting point, but if you already have some of the required software (like curl, for example), just skip the step that installs it.

There is a [script](http://www.ganshani.com/blog/2014/12/shell-script-to-setup-net-on-linux/) written by Punit Ganshani that should get you through many of the steps listed below but I'm going to go step by step to get a better idea of what's going on.

Prerequisites
-------------

There are quite a few packages that need to be installed in order for everything else to work and it's simplest to get them all at once.  

{% highlight bash %}
sudo apt-get install autoconf automake build-essential libtool git curl
{% endhighlight %}

Now, we need to get an updated version of [libuv](https://github.com/libuv/libuv) because the current implementation of [Kestrel](https://github.com/aspnet/KestrelHttpServer), a simple web server, requires a version of libuv that is not in the Linux Mint package manager.  I've got each step listed separately to help troubleshoot if anything goes wrong.

{% highlight bash %}
$ export LIBUV_VERSION=1.0.0-rc2
$ curl -sSL https://github.com/joyent/libuv/archive/v${LIBUV_VERSION}.tar.gz | sudo tar zxfv - -C /usr/local/src
$ cd /usr/local/src/libuv-$LIBUV_VERSION
$ sudo sh autogen.sh
$ sudo ./configure
$ sudo make
$ sudo make install
$ cd ~
$ sudo rm -rf /usr/local/src/libuv-$LIBUV_VERSION
$ sudo ldconfig
{% endhighlight %}

Configure git
-----------

We'll be using git to manage our source and deploy our application.  Many package managers can use git to pull down packages as source as well.

Since we already installed git in the step above, we just need to do some basic configuration. For more configuration options, see the [getting started](http://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup) section of the [git book](http://git-scm.com/book/en/v2).

{% highlight bash %}
$ git config --global user.name "John Doe"
$ git config --global user.email johndoe@example.com
{% endhighlight %}

Get Node.js
-----------

I prefer to use [NVM](https://github.com/creationix/nvm) to manage node.js, and to get it you should run the following command:

{% highlight bash %}
$ curl https://raw.githubusercontent.com/creationix/nvm/v0.22.0/install.sh | bash
{% endhighlight %}

Running this will put the following block of code in your .profile file:

{% highlight bash %}
export NVM_DIR="/home/andorbal/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
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

$ nvm alias default v0.10.35
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
$ sudo apt-get install mono-complete
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

Get KVM
-------

Now we'll get the K version manager and use it to install K. Installing it follows the same pattern as NVM: download a script and pipe it into a shell to execute immediately:

{% highlight bash %}
$ curl -sSL https://raw.githubusercontent.com/aspnet/Home/master/kvminstall.sh | sh && source ~/.kre/kvm/kvm.sh
{% endhighlight %}

Either source your .bashrc or reopen your terminal window and run the next set of commands.

{% highlight bash %}
$ kvm upgrade
Determining latest version
Latest version is 1.0.0-beta1
Downloading KRE-Mono.1.0.0-beta1 from https://www.nuget.org/api/v2
Installing to /home/andorbal/.kre/packages/KRE-Mono.1.0.0-beta1
Adding /home/andorbal/.kre/packages/KRE-Mono.1.0.0-beta1/bin to process PATH
Setting alias 'default' to 'KRE-Mono.1.0.0-beta1'

$ k --version
1.0.0-beta1-10662
{% endhighlight %}

KPM checks certificates when downloading packages and mono doesn't know about some of the certificates we need. A simple solution is to pull in all the certificates that Firefox knows about so that's what we'll do.

{% highlight bash %}
$ mozroots --import --ask-remove
{% endhighlight %}

Let's Test!
-----------

To verify that everything works, we're going to run the HelloMvc application from the asp.net samples folder.  Let's get that now.

{% highlight bash %}
$ mkdir work && cd work
$ git clone https://github.com/aspnet/home aspnet-home && cd aspnet-home/samples/HelloMvc
{% endhighlight %}

Now we're going to restore all the packages needed to run the application.  This took a few minutes on my laptop, but it _is_ about 7 years old.

{% highlight bash %}
$ kpm restore
{% endhighlight %}

When the restore finishes, it's time to see if all our work has paid off!

{% highlight bash %}
$ k kestrel
{% endhighlight %}

After you see 'started' in the output, open a browser and go to [http://localhost:5004](http://localhost:5004).  If you see the standard asp.net welcome page, congratulations: you can now run asp.net applications on Linux!  

Next time, we'll set up our [editing environment]({% post_url 2015-01-11-aspnet-on-linux-02-editing %}).
