---
layout: post
title:  "Asp.net on Linux: Part 3: Creating the project"
date:   2015-01-17 22:33:00
categories: aspnet linux aspnet_on_linux
---
{% include posts-aspnet-on-linux.html %}

We're going to create the project shell today.  We'll add tools to generate the project for us and set up a client library package manager.  We'll also set up the beginning of our build system.  So let's get started!

Yeoman
------

[Yeoman](http://yeoman.io/) is a tool designed to help build client side applications.  There are a large number of generator plugins, but today we'll be using the [aspnet generator](https://www.npmjs.com/package/generator-aspnet) plugin.  Let's get them both now.

To make things simple, lets set our default version of node so that we don't have to keep telling nvm which version to use.  We should have done this when we installed nvm, and I've updated that post to include this step.

{% highlight bash %}
$ nvm use 0.10
$ nvm alias default v0.10.35
{% endhighlight %}

Once that's done, we're going to install the tools we'll need.

{% highlight bash %}
$ npm install -g generator-aspnet gulp nodemon bower
{% endhighlight %}

When this completes, you'll have Yeoman and Gulp installed.  We've talked about Yeoman, but we'll get to Gulp, nodemon, and Bower later.

Create the application
----------------------

We're finally ready to create our application!  I prefer to do my work in ~/work, but you can create your directory anywhere you'd like.

{% highlight bash %}
$ mkdir aspnet-demo && cd aspnet-demo
$ git init
$ npm init
{% endhighlight %}

Npm will ask you quite a few questions.  Some of them, like author, have obvious answers.  However, if you don't know the answer to any of them you can just leave them blank; the questions are just used to populate the package.json file.

We'll use Yeoman to generate the shell of the web site and a few other files that we'll need.

{% highlight bash %}
$ yo aspnet
{% endhighlight %}

Select MVC Application when it asks what kind of application you want to create.  Enter 'web' when it asks what to name the application.  The name can be whatever you want, but it will be easier to follow along if you stick with my names.

Let's make sure we can run the application!  Navigate to the web directory, restore the NuGet packages, and start the server:

{% highlight bash %}
$ cd web
$ kpm restore
$ k kestrel
{% endhighlight %}

Open a browser and navigate to 'http://localhost:5004'.  You should see the default asp.net web site.  If everything looks good, hit enter in your terminal and then ctrl-c to stop kestrel.

Now we're going to save a project in Sublime Text so we can get Intellisense and the other benefits of OmniSharp.  Open Sublime Text and select "File \| Open Folder".  From the dialog, select "aspnet-demo/web".  Now, select "Project \| Save Project As..." and save the project file in the "aspnet-demo/web" folder.  You can name the project whatever you want, but I'm going to name it "aspnet-demo-web.sublime-project".  Once it's saved, open the file in Sublime Text and add the "solution_file" entry to the bottom of the file so that it looks like this:

{% highlight js %}
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

Build and run scripts
---------------------

We can run our application, but as it is we'll have to stop and restart the server after each change we make.  Restarting is quick, but even a few seconds adds up over time.  It would be nice if the server could restart itself after we make some changes.  This is where [nodemon](http://nodemon.io/) comes in.  Nodemon watches for file changes and restarts a script when it detects them.

If you want to see this working, run the following command:

{% highlight bash %}
$ nodemon --exec 'k kestrel' --ext cs
{% endhighlight %}

This starts nodemon.  It will run the script `k kestrel` and restart this script when any `*.cs` file changes.

Navigate to 'http://localhost:5004' and you should see the default asp.net site like before.  Now edit `Controllers/HomeController.cs` and change the value of "Name" on line 17 to something else.  When you save the file, you should see the server restarting in your terminal.  When it finishes, refresh your browser and you should see your changes.  

There is a project called [kmon](https://github.com/henriksen/kmon) that is a little simpler to use from the command line, but nodemon is easier to use from gulp.

[Gulp](http://gulpjs.com/) is a simple but powerful task runner built in javascript.  We're going to make use of it to pre-process SASS files, merge css and js files into single resources, and run our development server.  We're going to install quite a few plugins that will make our lives easier.

{% highlight bash %}
$ npm install --save-dev gulp-nodemon main-bower-files gulp-concat gulp-sass
{% endhighlight %}

Once the plugins have finished downloading, we're going to use Yeoman to create our Gulpfile and Bower config files.

{% highlight bash %}
$ yo aspnet:Gulpfile
$ yo aspnet:BowerJson
{% endhighlight %}

[Bower](http://bower.io) is a package manager that focuses on the front-end of your application.  Using Bower makes it easier to get client side resources because it handles dependencies and makes upgrading simpler.

Let's use it to get jQuery, which we'll use to test this setup.  The "--save" parameter tells Bower to save the dependency in the bower.json file that we created earlier.

{% highlight bash %}
$ bower install jquery --save
{% endhighlight %}

Add "scripts/global.js" to your "web" project and add the following script:

{% highlight js %}
$(() => {
  $('#test').html("This is from javascript!");
});
{% endhighlight %}

Also add a "scripts/global.scss" file as well.

{% highlight sass %}
#test {
  color: #FF0000;
}
{% endhighlight %}

Now open the _Layout.cshtml and add `<div id="test" />` above the footer in the body of the document.  Also make the following change near the bottom of the file:

{% highlight html %}
<!-- Replace the following line -->
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>

<!-- With this -->
<script src="js/script.js"></script>
{% endhighlight %}

Finally, add the following style link to the end of the head element:

{% highlight html %}
<link rel="stylesheet" href="css/styles.css" />
{% endhighlight %}

You may have noticed that we added a reference to `js/script.js`, but that file doesn't exist.  The same is true of `css/styles.css`.  What's more, the stylesheet we created was a [Sass](http://sass-lang.com/) file which browsers don't understand.  We'll use gulp to address these issues.

Update the gulpfile.js created earlier to look like this:

{% highlight js %}
/*
This file is the main entry point for defining Gulp tasks and using Gulp plugins
To learn more visit: https://github.com/gulpjs/gulp/blob/master/docs/README.md
*/
'use strict';

var gulp = require('gulp');
var mainBowerFiles = require('main-bower-files');
var concat = require('gulp-concat');
var sass = require('gulp-sass');
var nodemon = require('gulp-nodemon');

// Compile and concatenate scripts
gulp.task('scripts', function() {
    return gulp.src(mainBowerFiles().concat("scripts/**/*.js"))
      .pipe(concat('scripts.js'))
      .pipe(gulp.dest('wwwroot/js'));
});

// Compile and concat styles
gulp.task('sass', function () {
    gulp.src('styles/**/*.scss')
        .pipe(sass())
        .pipe(concat('styles.css'))
        .pipe(gulp.dest('wwwroot/css'));
});

// Watch task that rebuilds scripts and styles when files change
gulp.task('watch', function () {
  gulp.watch('**/*.js', ['scripts']);
  gulp.watch('**/*.scss', ['sass']);
});

// Run the web server and restart on any changes
gulp.task('daemon', function () {
  nodemon('--ext cs --exec "k kestrel"')
    .on('start', ['watch'])
    .on('restart', function () {
      console.log('restarted!');
    });
});

// The default task (called when you run `gulp` from CLI)
gulp.task('default', ['daemon']);
{% endhighlight %}

Save the file and run it:

{% highlight bash %}
$ gulp
{% endhighlight %}

This does quite a lot!  When you run gulp with no parameters, it starts the task named 'default'.  In our case, the default task does nothing by itself; it just creates a dependency on the 'daemon' task.  This task runs nodemon like we did manually near the top of this post.  The difference between manually running nodemon and running it through gulp is that we can hook into events that it raises.  For example, when it restarts, we print a message notifying us of that.

What's more interesting is what happens when nodemon starts: we start the 'watch' task.  This task sets up two gulp watches that will be responsible for processing our javascript and Sass files.  When a javascript file changes, the 'scripts' task will be run.  When a Sass file changes, the 'sass' task runs.

The 'scripts' task gets a list of all the scripts that Bower has retrieved and adds any javascript file we've created in the 'scripts' directory.  It then merges all the files into a single file named 'scripts.js' and saves it into the `wwwroot/js` directory.

The 'sass' task is similar.  It gets a list of all Sass files in the 'styles' directory and runs it through the Sass processor which converts it to normal css.  Then, like the 'scripts' task, it merges all the files into a single file and saves it into the `wwwroot/css` directory.

That's it!  Now you can develop an asp.net vNext application with as little friction as possible.

Next time, we're going to add tests and use gulp to run them automatically.