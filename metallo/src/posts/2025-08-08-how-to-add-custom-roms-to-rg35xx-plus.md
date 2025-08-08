---
title: Porting save files from Delta iOS to the RG35XX Plus
description: How to add roms and save files to the RG35XX Plus 2nd SD card on the stock OS
tags:
- Espresso
---

Here's another off topic, retro gaming post.
I got a bit carried away by the nostalgia of [playing Pokémon Emerald](https://mokacoding.com/blog/delta-emulator-pokemon-emerald-starters/) and ended up buying an RG35XX Plus to play on instead of my phone.

![RG35XX Plus](https://anbernic.com/cdn/shop/files/RG35XXPLUS_9d34eb03-285b-4466-9273-a38697abc96e.jpg)

I didn't want to restart the game, so I looked into how to import the save file from the session on Delta into the RG35XX.
I was overwhelmed by the amount of conflicting information and unnecessarily long YouTube videos.
Seriously, when did tutorials become like cooking recipes, where the author spends hundreds of characters telling you about her grandma and the memories of baking the cake together?
Get to the point!

So, here are the steps that worked for me starting with a brand new device to which I added a new SD in the second slot.

1. Put the new SD in the RG35XX and boot the device. This will generate the required folders in the SD.
2. Extract the SD and connect it to your PC or Mac.
3. On the Delta iOS app, export the save file by long pressing on the game, selecting Manage Save File, then Export Save File (see screenshot below).
4. Save the `.sav` file somewhere you can access from your PC or Mac.
5. From your PC or Mac, move the save file in `roms/<console name>`. In my case this was `roms/GBA`. Notice this is the same folder where the `.gba` ROMs are.
6. Turn the RG35XX Plus on and launch the game.
7. _Done._

![Screenshot of the Manage Save File menu in Delta iOS](https://mokacoding.s3.amazonaws.com/delta-save-file.jpg)

Notice that in Delta the in-game save files are different from the [saved states](https://faq.deltaemulator.com/using-delta/save-states).
