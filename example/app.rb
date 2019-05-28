require 'habu/setup'
require_relative 'user'
require_relative 'new_user_service'

# Create a new container
container = Habu::Container.new

# Register user_repository service by passing the block as service factory
container[:user_repository] { User }

# Call Habu::Container#new to get instance
new_user = container.new(NewUserService).call("hanachin")
# => #<struct User name="hanachin">

# Factory block take a container as argument
container[:new_user] do |c|
  # You can get the service object by calling Container#[](service_name)
  NewUserService.new(c[:user_repository])
end
new_user = container[:new_user].call("hanachin")
# => #<struct User name="hanachin">

# Using container as refinements for shorthand for container.new
using container.to_refinements
new_user = NewUserService.new.call("hanachin")
# => #<struct User name="hanachin">
