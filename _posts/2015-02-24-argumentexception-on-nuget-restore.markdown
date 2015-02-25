---
layout: post
title:  "ArgumentException on NuGet (kpm) restore"
date:   2015-02-24 19:15:00
categories: dotnet nuget visual_studio 
---

I just installed Visual Studio 2015 CTP 6 on a machine that had CTP 5 and multiple K runtimes that all worked correctly.  However, after the install completed, I got the following error when trying to run an existing application:

{% highlight bash %}
System.ArgumentException: An item with the same key has already been added.
   at System.ThrowHelper.ThrowArgumentException(ExceptionResource resource)
   at System.Collections.Generic.Dictionary`2.Insert(TKey key, TValue value, Boolean add)
   at System.Collections.ObjectModel.KeyedCollection`2.AddKey(TKey key, TItem item)
   at System.Collections.ObjectModel.KeyedCollection`2.InsertItem(Int32 index, TItem item)
   at System.Collections.ObjectModel.Collection`1.Add(T item)
   at NuGet.CollectionExtensions.AddRange[T](ICollection`1 collection, IEnumerable`1 items)
   at NuGet.NetPortableProfileTable.BuildPortableProfileCollection()
   at NuGet.NetPortableProfileTable.GetProfileData()
   at System.Lazy`1.CreateValue()
   at System.Lazy`1.LazyInitValue()
   at System.Lazy`1.get_Value()
   at NuGet.NetPortableProfileTable.GetProfile(String profileName)
   at NuGet.NetPortableProfile.Parse(String profileValue)
   at NuGet.VersionUtility.IsPortableLibraryCompatible(FrameworkName frameworkName, FrameworkName targetFrameworkName)
   at NuGet.VersionUtility.IsCompatible(FrameworkName frameworkName, FrameworkName targetFrameworkName)
   at NuGet.VersionUtility.<>c__DisplayClass36_0`1.<TryGetCompatibleItems>b__5(IGrouping`2 g)
   at System.Linq.Enumerable.WhereListIterator`1.MoveNext()
   at System.Linq.Buffer`1..ctor(IEnumerable`1 source)
   at System.Linq.OrderedEnumerable`1.<GetEnumerator>d__0.MoveNext()
   at System.Linq.Enumerable.FirstOrDefault[TSource](IEnumerable`1 source)
   at NuGet.VersionUtility.TryGetCompatibleItems[T](FrameworkName projectFramework, IEnumerable`1 items, IEnumerable`1&compatibleItems)
   at Microsoft.Framework.Runtime.NuGetDependencyResolver.<GetDependencies>d__13.MoveNext()
   at Microsoft.Framework.Runtime.WalkContext.<>c__DisplayClass1_0.<Walk>b__0(Node node)
   at Microsoft.Framework.Runtime.WalkContext.<>c__DisplayClass5_0.<ForEach>b__0(Node node, Int32 _)
   at Microsoft.Framework.Runtime.WalkContext.ForEach[TState](Node root, TState state, Func`3 visitor)
   at Microsoft.Framework.Runtime.WalkContext.ForEach(Node root, Action`1 visitor)
   at Microsoft.Framework.Runtime.WalkContext.Walk(IEnumerable`1 dependencyResolvers, String name, SemanticVersion version, FrameworkName frameworkName)
   at Microsoft.Framework.Runtime.DependencyWalker.Walk(String name, SemanticVersion version, FrameworkName targetFramework)
   at Microsoft.Framework.Runtime.DefaultHost.Initialize()
   at Microsoft.Framework.Runtime.DefaultHost.GetEntryPoint(String applicationName)
   at Microsoft.Framework.ApplicationHost.Program.ExecuteMain(DefaultHost host, String applicationName, String[] args)
   at Microsoft.Framework.ApplicationHost.Program.Main(String[] args)
{% endhighlight %}

This is caused by having duplicate profiles listed in more than one framework version.  These are stored at `c:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETPortable` in individual directories per framework.  In my case, the problem was `profile158` in `v4.0\profiles` and `v4.5\profiles`.

![Duplicate entries](https://andybenzblog.blob.core.windows.net/images/duplicate-profiles.png)

This happens to me every time I install a new version of Visual Studio and I believe it started after installing the Xamarin tools, but I don't have any proof of this.  To fix the problem, I just move the `profile158` folder out of the `v4.5` directory and into a backup location.  I chose this one instead of the `v4.0` version because `v4.0` included the Xamarin profiles, which is something I want to keep around.

It's a little frustrating, but it's an easy fix...