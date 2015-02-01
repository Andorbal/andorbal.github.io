---
layout: post
title:  "Windows 8 Issues"
date:   2013-01-27 12:00:00
categories: windows
redirect_from: /blog/2013/1/27/windows-8-issues/
---

Yesterday, I decided to install Windows 8 on my basement computer, which I primarily use for audio recording.  Windows 7 was working just fine, but it's the only computer I own that has the ability to run hyper-v, which is necessary to run the Windows Phone 8 emulator.  I installed Windows 8 on my laptop and ensured that all my hardware worked in at least some fashion in Windows 8, so I felt pretty confident.

Despite not wanting to boot from a flash drive, the install went very smoothly.  I got a stable base system going with all current updates installed, though it was taking just over a minute to boot.  This was odd because my laptop, which is of similar age and configuration  boots in less than 10 seconds.  Before calling it a night, however, I started the VS Express for Windows Phone install.  When I came down to the computer this morning, it was asking for a reboot so I obliged.

At that point, the computer just hung on the Windows 8 logo.  No HD light flashing, no other feedback.  Nothing.

I rebooted a few times, and eventually got to the system repair screen.  Since I hadn't really done much since installing, I just let it revert to the last known good restore point.  After a few minutes, it finished and I was able to boot again.

I did a little searching and some threads suggested flashing the motherboard's bios.  I don't usually like doing that, but as it turns out, the bios I had was 6 years old, and there was one that was 2 years newer.  Still old, but I figured I'd give it a shot.  The bios flash finished, but wiped all my settings.  It wasn't a big deal, since I hadn't changed much so I entered the bios menu after the reboot and set things back the way I thought I had them.

I saved the settings and rebooted again.  This time, Windows started MUCH faster.  All was not right in the world, because my keyboard wasn't responding.  I remembered the legacy USB keyboard setting was disabled in the bios, so I went back in and enabled it.  This time, Windows took over a minute to boot, but the keyboard worked.  I couldn't imagine that Windows would need the bios to support a legacy USB keyboard, so I changed the setting back to disabled, rebooted, got the same fast startup speed, and was greeted with a working keyboard.  My plan was to let it reboot, and then just do the unplug-replug routine that seems to get Windows to recognize peripherals.  But I didn't need to do that.

After all that, I installed VS Express for Windows Phone again, and other than having to manually enable Hyper-V, it all worked flawlessly!  I just installed my audio interface drivers, checked that my DAW works, and I think I'm in business!