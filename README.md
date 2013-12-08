Has Response
============
Extremely simple API support for Rails models

Description
-----------

Has Response provides very simple support for turning model instances into JSONifiable hashes for use in API responses. The hashes contain only the attributes that are specified, and they can contain hashes of N-order associations as well.

Installation
------------

Add Has Response to your Gemfile:

```ruby
gem 'has_response'
```

Usage
-----

Include HasResponse and define to\_response in your model:

```ruby
class User < ActiveRecord::Base
  include HasResponse

  def to_response
    {
      id: id,
      username: username,
      avatar_url: avatar.url(:thumb)
    }
  end
end
```

There's nothing special here yet, but you can now return JSON of users more easily in controllers:

```ruby
class UsersController < ApplicationController
  def show
    user = User.find(params[:id])
    render :json => user.to_response
  end
end
```


Say you want to include the user's Location in your response, too. Set up Location:

```ruby
class Location < ActiveRecord::Base
  include HasResponse

  def to_response
    {
      id: id,
      city: city,
      state: state
    }
  end
end
```

And the association:

```ruby
class User < ActiveRecord::Base
  #...
  belongs_to :location
  #...
end
```

Then change `user.to_response` to:

```ruby
user.to_response_with(:location)
```

This will return:

```ruby
{
  id: 1,
  username: "johndoe",
  avatar_url: "http://mysite.com/myavatar.jpg",
  location: {
    id: 1,
    city: "San Francisco",
    state: "CA"
  }
}
```

If you want to add additional columns or method values to any responses, those can be included just like associations are included.  If User responds to a method named `posts_count`, you can easily include that, too:

```ruby
user.to_response_with(:location, :posts_count)
```

This will return:

```ruby
{
  id: 1,
  username: "johndoe",
  avatar_url: "http://mysite.com/myavatar.jpg",
  location: {
    id: 1,
    city: "San Francisco",
    state: "CA"
  },
  posts_count: 2
}
```

You can include associations of N-order.  To include a User's Posts, and those Posts' Comments, including their User, use:

```ruby
user.to_response_with(:location, :posts => {:comments => :user})
```

This will return:

```ruby
{
  id: 1,
  username: "johndoe",
  avatar_url: "http://mysite.com/myavatar.jpg",
  location: ...,
  posts: [
    {
      id: 1,
      title: "My First Post",
      content: "My first post!",
      comments: [
        {
          id: 1,
          content: "Great post!",
          user: {
            id: 2,
            username: "Jane Doe",
            avatar_url: "http://mysite.com/myavatar.jpg"
          }
        }
      ]
    }
  ]
}
```

License
-------

Has Response is released under the MIT License. Please see the MIT-LICENSE file for details.
