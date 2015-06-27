---
layout: post
title:  "Asp.net on Linux: Part 3: Creating the project"
date:   2015-06-26 20:33:00
categories: aspnet linux aspnet_on_linux
series_order: 3
---
{% include posts-aspnet-on-linux.html %}

We're going to create the project shell today.  We'll add tools to tools that will help us and set up a client library package manager.  We'll also set up the beginning of our build system.  So let's get started!

Yeoman
------

[Yeoman](http://yeoman.io/) is a tool designed to help build client side applications.  There are a large number of generator plugins, but today we'll be using the [aspnet generator](https://www.npmjs.com/package/generator-aspnet) plugin.  Let's get them both -- and a few other tools we'll use -- now.  The aspnet generator has templates to build entire projects for us, but we're going to use it for smaller chunks so we can see what goes into creating a project.

{% highlight bash %}
$ npm install -g yo generator-aspnet gulp nodemon bower
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

Let's create a new directory for the web application and use Yeoman to create the global project shell.

{% highlight bash %}
$ mkdir web
$ yo aspnet:JSON global
{% endhighlight %}

This creates an empty json file named global.json which defines the root of our application.  OmniSharp looks for this file to see which projects are associated with each other.  Populate the file with this:

{% highlight js %}
{
    "projects": ["web"]
}
{% endhighlight %}

We'll use Yeoman to create the shell of our application.

{% highlight bash %}
$ yo aspnet
{% endhighlight %}

Choose "Empty Application" and name the application 'web' to make it easier to follow along.  Navigate into the newly created directory and modify the `project.json` file.  Because we won't be supporing .NET Core yet, we can remove the `dnxcore50` entry.  Let's use Yeoman again to create a basic gulpfile.

{% highlight bash %}
$ yo aspnet:Gulpfile
{% endhighlight %}

[Gulp](http://gulpjs.com/) is a simple but powerful task runner built in javascript.  We're going to make use of it to pre-process SASS files, merge css and js files into single resources, and run our development server.  We're going to install quite a few plugins that will make our lives easier.

{% highlight bash %}
$ npm install --save-dev gulp gulp-nodemon gulp-bower main-bower-files gulp-concat gulp-sass
{% endhighlight %}

Now let's make sure we can run the application.  Navigate to the web directory, restore the NuGet packages, and start the server:

{% highlight bash %}
$ cd web
$ dnu restore
$ dnx . kestrel
{% endhighlight %}

Open a browser and navigate to 'http://localhost:5001'.  You should see "Hello World!".  If everything looks good, hit enter in your terminal to stop kestrel.

Build and run scripts
---------------------

We can run our application, but as it is we'll have to stop and restart the server after each change we make.  Restarting is quick, but even a few seconds adds up over time.  It would be nice if the server could restart itself after we make some changes.  This is where [nodemon](http://nodemon.io/) comes in.  Nodemon watches for file changes and restarts a script when it detects them.

If you want to see this working, run the following command:

{% highlight bash %}
$ nodemon --exec 'dnx . kestrel' --ext cs
{% endhighlight %}

This starts nodemon.  It will run the script `dnx . kestrel` and restart this script when any `*.cs` file changes.

Navigate to 'http://localhost:5001/' and you should see "Hello World!" as you did before.  Now edit `Startup.cs` and change "Hello World!" on line 22 to something else.  When you save the file, you should see the server restarting in your terminal.  When it finishes, refresh your browser and you should see your changes.

Bower
-----

[Bower](http://bower.io) is a package manager that focuses on the front-end of your application.  Using Bower makes it easier to get client side resources because it handles dependencies and makes upgrading simpler.

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

Open `web/Views/Home/Index.cshtml` and replace its contents with the following: 

{% highlight html %}
@{
    ViewBag.Title = "Home Page";
}

<div id="test" />
{% endhighlight %}

Then open the _Layout.cshtml and replace it with this:

{% highlight html %}
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>@ViewBag.Title</title>

        <link rel="stylesheet" href="~/css/styles.css" />
    </head>
    <body>
        @RenderBody()

        <script src="~/js/script.js"></script>
        @RenderSection("scripts", required: false)
    </body>
</html>

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
