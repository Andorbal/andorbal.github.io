---
layout: post
title:  "Editing on an iPad"
date:   2015-12-28 20:00:00
categories: programming development ipad mobile
---

I'm trying an experiment that I never thought I would: writing code on an iPad without a hardware keyboard. I certainly don't plan on doing anything too heavy, but with an 18 month old running around, I'm looking for a way to squeeze in a few minutes of coding here and there. Also, I'm trying to further justify buyimg the iPad mini 4!

There are two apps that are making this journey possible: [Textastic](http://www.textasticapp.com) and [Working Copy](http://workingcopyapp.com). Textastic is the code editor that I will be using and Working Copy allows me to interact with my git repositories. It's not a perfect combination, but it is much better than I expected.

Textastic has made me believe that writing code on an iPad without a hardware keyboard was even possible. I didn't want to try prior to this because I knew that I would have to frequently switch between letters, numbers, and special characters. Tapping three times to get a single character was not appealing to me. Textastic gets around this with a row of buttons above the keyboard that have five characters each. For example, one button has 0 through 4 on it. To type a zero, I just have to tap the button once. To type a 1, I tap the button and swipe up and left as I let go. The other corners hold the rest of the numbers and I would need to swipe to the appropriate corner to type them. It works much better than I expected and the more I use them, the more natural it feels. It is obviously not as quick as a real keyboard, but using two thumbs is already slower than using ten fingers so I won't complain.

I was also concerned about navigating the text files because I frequently need to position the cursor in a precise spot and the normal tapping is too clumsy for that. Their solution is to use gestures to move the cursor once you've put it near where you want it. I can swipe with one finger to the left or right to move the cursor one space, or swipe with two fingers to move to the beginning or the end of a word. This is a relatively slow process but it is much less frustrating than trying to repeatedly position the cursor manually.

It's great to be able to edit files, but Textastic does not interact with git, so it didn't seem loke it would work for me. Then I stumbled upon [an article](http://blach.io/2015/05/26/using-git-on-your-ipad-or-iphone-with-working-copy-and-textastic/) about using Textastic with an app called Working Copy. It seemed promising, so I decided to give it a try. Cloning a repo is easy, and I was able to add a second remote just as easily.

It is simple to open a file from Working Copy in Textastic, but it's less obvious how to create a new one. Textastic let's you create a new file using local storage but not when using a storage provider. You need to create the file first in Working Copy and then open it in Textastic. Not a big deal, but it's a little annoyance. Another issue is that you cannot open an entire folder from Working Copy in Textastic. I'm not sure if this will be a major hassle yet, as the recent file feature may be enough. I also don't see any indication of whether my file has been saved and there doesn't seem to be a way to manually save. I just need to trust that Textastic is saving frequently enough, I guess. Finally, this combination seems to chew through battery. I started writing this post about an hour ago and I am down 10% from where I started.

Writing this post on an iPad wasn't too bad. I'm looking forward to writing some real code to see how it fares. Now I'm off to Working Copy to commit and push!