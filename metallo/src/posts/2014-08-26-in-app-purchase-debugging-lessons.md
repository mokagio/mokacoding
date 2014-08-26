---
title: In-App Purchase Debugging Lessons
description: A couple of tips learnt the hard way on how to develop and debug In App Purchase support in an iOS app.
tags:
- iOS
---

Here's a couple of lessons regarding developing In-App Purchase that I learnt the hard way while working of [Fineants](https://itunes.apple.com/au/app/fineants-savings-tracker/id888444078?mt=8). I'll leave them here as a self memo for the next time.

### Never ever quit the app while the purchase is in progress

Let me say it again: **never ever quit your app while a purchase is in progress**.

If you do, you'll see this alert popping up every time, regardless of what you do:

<img src="http://mokacoding.s3.amazonaws.com/2014-08-26-iap-already-purchased-hasnt-been-downloaded.png" alt="Item has already been purchased but it hasn't been downloaded error screenshot"/>

Picking from the [In-App Purchase FAQ](https://developer.apple.com/library/ios/technotes/tn2259/_index.html#//apple_ref/doc/uid/DTS40009578-CH1-FREQUENTLY_ASKED_QUESTIONS): _"You are getting the "You've already purchased this In-App Purchase but it hasn't been downloaded." error message because you did not call `SKPaymentQueue`'s `finishTransaction:` method in your application. "_

Looking through the [In-App Purchase Programming Guide](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/StoreKitGuide/Chapters/DeliverProduct.html) we discover that not finishing a transaction is a problem, because:

> [...] even during testing, failing to finish the transaction can cause problems: unfinished transactions remain in the queue indefinitely, which could interfere with later testing.

Which brings us back to the start: you'll keep getting the for and _indefinite_ amount of time. This means you'll have to setup a new test account, or go home and try again tomorrow!

### Log a lot

To be sure that the IAP process is behaving as expected add some serious logging in the code that handles it.

For sure, to debug it while implementing it breakpoints are very effective. But once you are sure that it's working and, say you're doing some QA to make sure you didn't break anything before realising an update, having logs in the console tracking how the process went is priceless.

Even more important is **logging the reason a transaction has failed**. 

[`SKPaymentTransaction`](https://developer.apple.com/library/ios/documentation/StoreKit/Reference/SKPaymentTransaction_Class/Reference/Reference.html) has an [`error`](https://developer.apple.com/library/ios/documentation/StoreKit/Reference/SKPaymentTransaction_Class/Reference/Reference.html#//apple_ref/occ/instp/SKPaymentTransaction/error) property which is _"an object describing the error that occurred while processing the transaction"_.

### Test with a good connection

<img src="http://mokacoding.s3.amazonaws.com/2014-08-26-iap-cannot-connect-store.png" alt="Cannot connect to iTunes Store error screenshot"/>

Thanks to the `error` property above I once found out that the failure I'd been experiencing for the past 10 minutes were due to the fact that the app wasn't able to connect to the iTunes Store because of the crappy Wi-Fi I was using.

---

iOS 8 brought the possibility of testing IAP on the Simulator. I hope Apple will soon improve the IAP test accounts, giving developers the possibility to reset and remove transactions.

_Enjoy earning money withs In App Purchase_
