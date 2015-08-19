---
layout: post
title: AFNetworking custom response serializer to add error information
description: "How to implement a custom AFNetworking response serializer to read the failure response data and populate the callback error with it."
tags:
  - Espresso
  - iOS
  - Objective-C
---

Good network APIs add helpful messages to failing responses. For example:

```
{
  "error": "You are not authorized to access this resource."
}
```

A possible approach to notify the user of an iOS app consuming network APIs that an error has been returned by the server is to show such error data in some way.

When using [AFNetworking](https://github.com/AFNetworking/AFNetworking) the first thought that might come to mind is: I'll read the response data in the failure callback. But that is not possible, unlike the success callback the failure one doesn't have a `responseObject` parameter.

[This issue](https://github.com/AFNetworking/AFNetworking/issues/2410) is relevant to the topic, and in particular [Mattt's comment](https://github.com/AFNetworking/AFNetworking/issues/2410#issuecomment-63304245).

> [...] the intended strategy is for API consumers to create their own response serializers to handle failures in such a way that populates the resulting `NSError` in the failure case with all necessary information to either communicate or recover from that particular error.
>
> If, for example, an API were to send an error message as JSON, the response serializer might populate the localizedDescription and/or localizedFailureReason from fields in that document.

That makes sense. So how to create a custom response serializer?

Since our example talks of JSON APIs the simplest thing to do is to subclass `AFJSONResponseSerializer`. Another option would be to roll out our own `NSObject` conforming to `AFURLResponseSerialization`, which is the protocol all serializers need to conform to.

A serializer object needs to conform to `AFURLResponseSerialization`. So one option is to use a PONSO, plain old `NSObject`, and make it conform to the protocol. On the other hand what we are trying to achieve is adding a bit of functionality, adding info from the response to the failure callback error, to the standard JSON serialiation. So let's simply subclass `AFJSONResponseSerializer`.

```objc
@interface CustomJSONSerializer: AFJSONResponseSerializer
@end

@implementation CustomJSONSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error {
  // Let the superclass do its work.
  // Run the custom code only if there is an error.
  id responseToReturn = [super responseObjectForResponse:response
                                                    data:data
                                                   error:error];
  if (!*error) { return responseToReturn; }

  NSError *parsingError;
  NSDictionary *JSONResponse = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingAllowFragments
                                                                 error:&parsingError];

  if (parsingError) { return responseToReturn; }

  // Populate the error's userInfo using the parsed JSON
  NSMutableDictionary *userInfo = [(*error).userInfo mutableCopy];
  NSString *errorDescription = JSONResponse[@"error"];
  userInfo[NSLocalizedDescriptionKey] = errorDescription;

  NSError *annotatedError = [NSError errorWithDomain:(*error).domain
                                                code:(*error).code
                                            userInfo:userInfo];
  (*error) = annotatedError;

  return responseToReturn;
}

@end
```

That's it 👌.

Note how the error is managed. Because it is a `NSError *__autoreleasing *` instance we need to access is like this: `(*error)`.

## Food for Thought

* Dig down into why we need to use `(*error)`.
* What other options do we have to achieve the same result? For example using the `AFNetworkingOperationFailingURLResponseDataErrorKey` key in the default failure callback `NSError`'s `userInfo`.
* How does [Alamofire](https://github.com/Alamofire/Alamofire).
