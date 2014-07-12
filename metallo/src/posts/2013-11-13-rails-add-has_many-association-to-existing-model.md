---
date: 2013-11-13
title: "Rails: adding a new has_many association to an existing model"
tags:
- Ruby
- Ruby on Rails
description: A little guide on how to edit an existing model adding a new has_many association
slug: rails-add-has_many-association-to-existing-model
---

I'm gonna quick go through the process of how to evolve an existing schema adding new models and association in Ruby on Rails. I had to do this for work this morning and had to put together pieces from the [Rails Guides](http://guides.rubyonrails.org/index.html) and other resources.

The starting point is a schema with a single **items** table. We want to have a **level** system, where each level is made up by a group of **challenges**, and each challenge contains a number of items.

Note: I'm using [rspec](https://github.com/rspec/rspec) and [shoulda](https://github.com/thoughtbot/shoulda) to write the tests.

###Step 1 - Create the `Challenge` model

Creating a new empty model is easy, just run

```bash
rails g model challenge
```

and the resulting migration

```bash
rake db:migrate RAILS_ENV=development
```

###Step 2 - Add the association "challenge has many items"

We want to have a model that makes these tests pass:

```ruby
describe Challenge do
  it { should have_many :items }
end

describe Item do
  it { should belong_to :challenge }
end
```

The first thing would be to write a migration, but there is no way to generate a migration for an association with the `rails generate migration` command. So we have to do it manually, and then write the migration to update the db and schema.

```ruby
class Challenge < ActiveRecord::Base
	has_many :items
end

class Item < ActiveRecord::Base
	belongs_to :challenge
end
```

```bash
rails g migration AddItemsAssociationToChallenge
```

This is the code to put in the resulting migartion file

```ruby
class AddItemsAssociationToChallenge < ActiveRecord::Migration
  def self.up
  	add_column :items, :challenge_id, :integer
  	add_index 'items', ['challenge_id'], :name => 'index_challenge_id' 
  end
  
  def self.down
  	remove_column :items, :challenge_id
  end
end
```

Finally let's run `rake db:migrate` and `rspec` (because we're using [binstub](http://mislav.uniqpath.com/2013/01/understanding-binstubs/) aren't we?) and everything should be fine.

###Step 3 – The Levels

The process for the levels will be the same as before, a good way to commit the steps to memory. We want this specs to pass:

```ruby
describe Level do
	it { should have_many :challenges }
end

describe Challenge do
	it { should belong_to :level }
end
```

So we generate a migration

```bash
rails g migration AddChallengesAssociationToLevel
```

and we write this inside it

```ruby
class AddChallengeAssociationToLevel < ActiveRecord::Migration
  def self.up
  	add_column :challenges, :level_id, :integer
  	add_index 'challenges', ['level_id'], :name => 'index_level_id' 
  end
  
  def self.down
  	remove_column :challenges, :level_id
  end
end
```

finally we cannot forget to manually update our models

```ruby
class Level < ActiveRecord::Base
	has_many :challenges
end

class Challenge < ActiveRecord::Base
	has_many :items
	belongs_to :level
end
```

That's all. Nothing incredibly hard, but still not obvious for someone who manly writes Objective-C. Happy coding!