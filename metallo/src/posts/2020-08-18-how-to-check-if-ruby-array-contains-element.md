---
title: How to check if array contains element with block in Ruby
tags:
- Ruby
- Espresso
---

Sometimes, you want to know if an array contains one or more elements based on a test function.

```ruby
[1,2,3,4].any? { |n| n > 2 }
# => true
```

If you need to get the first object that matches your criteria, you can use `find`.

```ruby
[1,2,3,4].find { |n| n > 2 }
# => 3
```
