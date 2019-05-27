# Habu

DI container

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'habu'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install habu

If you are using Rails, add this line to `config/boot.rb` immediately after `require 'bundler/setup'`.

    require 'habu/setup'

If you are not using Rails, add this line before using DI container.

    require 'habu/setup'

## Usage

```ruby
# new_user_service.rb
class NewUserService
  @Inject
  def initialize(user_repository)
    @user_repository = user_repository
  end

  def call
    @user_repository.new
  end
end

# app.rb
require 'habu/setup'
require 'habu/container'
require 'user'
require 'new_user_service'

# Create a new container
container = Habu::Container.new

# Register user_repository service by passing the block as service factory
container[:user_repository] { User }

# Call Habu::Container#new to get instance
new_user = container.new(NewUserService).call

# Factory block take a container as argument
container[:new_user] do |c|
  # You can get the service object by calling Container#[](service_name)
  NewUserService.new(container[:user_repository]).call
end
new_user = container[:new_user]

# Using container as refinements for shorthand for container.new
using container.to_refinements
new_user = NewUserService.new.call
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hanachin/habu.
