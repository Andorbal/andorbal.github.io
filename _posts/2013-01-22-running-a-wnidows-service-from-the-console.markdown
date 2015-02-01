---
layout: post
title:  "Running a Windows service from the console"
date:   2013-01-22 12:00:00
categories: windows service c# .net console
redirect_from: /blog/2013/1/22/running-a-wnidows-service-from-the-console/
---

Running a Windows service from a console is pretty straightforward, but I always forget the test for whether the exe is being run from a console or not.  I know it contains 'interactive', but that's not enough for Google to give me good results.  Luckily, I remembered seeing this in RavenDB, so I just checked out the source in GitHub and voila!

But just for reference, here's my basic shell for running a service from the console:

Program.cs:

{% highlight c# linenos %}
using System;
using System.ServiceProcess;
 
namespace ServiceTest
{
  static class Program
  {
    /// <summary>
    /// The main entry point for the application.
    /// </summary>
    static void Main()
    {
      if (Environment.UserInteractive)
      {
        Console.WriteLine("Hit enter to exit");
        var service = new Service1();
        service.Start();
        Console.ReadLine();
        service.Stop();
      }
      else
      {
        ServiceBase[] ServicesToRun;
        ServicesToRun = new ServiceBase[] 
        { 
          new Service1() 
        };
        ServiceBase.Run(ServicesToRun);
      }
    }
  }
}
{% endhighlight %}


Service1.cs:

{% highlight c# linenos %}
using System.ServiceProcess;
 
namespace ServiceTest
{
  public partial class Service1 : ServiceBase
  {
    public Service1()
    {
      InitializeComponent();
    }
      
    protected override void OnStart(string[] args)
    {
      Start();
    }
    
    protected override void OnStop()
    {
      Finish();
    }
    
    public void Start()
    {
      // Normal start stuff
    }
    
    public void Finish()
    {
      // Normal stop stuff
    }
  }
}
{% endhighlight %}