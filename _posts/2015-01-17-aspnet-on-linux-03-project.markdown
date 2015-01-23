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

When this completes, you'll have Yeoman and Gulp installed.  We've talked about Yeoman, but we'll get to Gulp, nodemon, and bower later.

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

We can run our application, but as it is we'll have to stop and restart the server after each change we make.  Instead, what we want to do is have that done for us.  This is where [nodemon](http://nodemon.io/) comes in.  Nodemon watches for file changes and restarts a script when it detects them.

If you want to see this working, run the following command:

{% highlight bash %}
$ nodemon --exec 'k kestrel' --ext cs
{% endhighlight %}

Navigate to 'http://localhost:5004', and you should see the default asp.net site like before.  Now edit `Controllers/HomeController.cs` and change the value of "Name" on line 17 to something else.  When you save the file, you should see the server restarting in your terminal.  When it finishes, refresh your browser and you should see your changes.  There is a project called [kmon](https://github.com/henriksen/kmon) that is a little simpler to use, but we're going to use a gulp task to run the server.

[Gulp](http://gulpjs.com/) is a simple but powerful task runner built in javascript.  We're going to make use of it to pre-process SASS files, merge css and js files into single resources, and run our development server.  We're going to install quite a few plugins that will make our lives easier.

{% highlight bash %}
$ npm install --save-dev gulp-nodemon main-bower-files gulp-jshint gulp-concat gulp-uglify gulp-rename gulp-sass
{% endhighlight %}

Once the plugins have finished downloading, we're going to use Yeoman to create our Gulpfile and Bower config files.

{% highlight bash %}
$ yo aspnet:Gulpfile
$ yo aspnet:BowerJson
{% endhighlight %}

Now, let's use Bower to get jQuery which we'll use to test this setup.  The "--save" parameter tells Bower to save the dependency in the bower.json file that we created earlier.

{% highlight bash %}
$ bower install jquery --save
{% endhighlight %}

Add "Views/Shared/global.js" to your "web" project and add the following script:

{% highlight js %}
$(() => {
  $('#test').html("This is from javascript!");
});
{% endhighlight %}

Also add a "Views/Shared/global.scss" file to the same location.

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

Update the gulpfile.js created earlier to look like this:

{% highlight js %}
/*
This file is the main entry point for defining Gulp tasks and using Gulp plugins
To learn more visit: https://github.com/gulpjs/gulp/blob/master/docs/README.md
*/
'use strict';

var gulp = require('gulp');
var mainBowerFiles = require('main-bower-files');
var jshint = require('gulp-jshint');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var rename = require('gulp-rename');
var sass = require('gulp-sass');
var nodemon = require('gulp-nodemon');

gulp.task('scripts', function() {
    return gulp.src(mainBowerFiles(/* options */).concat("Views/Shared/**/*.js"), { base: 'bower_components' })
      .pipe(concat('scripts.js'))
      .pipe(gulp.dest('wwwroot/js'));
});

gulp.task('sass', function () {
    gulp.src('Views/Shared/**/*.scss')
        .pipe(sass())
      .pipe(concat('styles.css'))
        .pipe(gulp.dest('wwwroot/css'));
});

// Watch Files For Changes
gulp.task('watch', function () {
  gulp.watch('**/*.js', ['scripts']);
  gulp.watch('**/*.scss', ['sass']);
});

gulp.task('demon', function () {
  nodemon('--ext cs --exec "k kestrel"')
    .on('start', ['watch'])
    //.on('change', ['watch'])
    .on('restart', function () {
      console.log('restarted!');
    });
});

// The default task (called when you run `gulp` from CLI)
gulp.task('default', ['demon']);
{% endhighlight %}