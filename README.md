# Route53::Web

`Route53::Web` is a (`Resque::Server`-inspired) micro-app wrapping
[ruby_route_53](https://github.com/pcorliss/ruby_route_53)
provides a UI for viewing how your Route53 is configured (later,
the idea is to also be able to edit/add stuff). Exciting, no?

Simple enough to get going. In your `Gemfile`:

    gem 'route53web'

Shocking. Needs some AWS configuration:

    Route53::Web.config = { :access => '123', :secret => 'abc' }

Now just mount it somewhere -- `routes.rb`, maybe?:

    mount Route53::Web, :at => '/route53'

...or use a `config.ru`, whatever really:

    require 'route53web'
    run Route53::Web.new


## Contributing to route53web

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it.
* Please try not to mess with the Rakefile, version, or history.

## Copyright

Copyright (c) 2011 Ryan Funduk. See LICENSE.txt for
further details.

