# APIc

## What is it?

APIc is a bolt on API console for Rails 3+ applications.
It rounds up your endpoints and makes it dead easy to configure, send, review and replay any request.


![Screen 1](https://github.com/randym/apic/raw/master/sample.png)

What you need to do?

add the gem to your Gemfile

```
gem 'apic'
```

Run the generator!

```
rails generate apic:install
```

If you are using bundler:

```
bundle exec rails generate apic:install

```

Spin up your Rails application and navigate to

```
localhost:3000/apic
```



## Configuration

### Controller Parameters

APIc needs to know about the parameters your PUT, PATCH and UPDATE requests require.
To make this as simple and painless as possible, APIc exposes a DSL to your controllers so you can specify what you need.
APIc knows what type of routes are available and will automatically add in the _method parameter and value for PATCH and DELETE requests.

```
class TestController < ActionController.base

  apic_action_params create: [:name, :acceptance]

  def create
    # all your cool stuff that creates a new object
  end

end
```

### Initializer

The apic:install generator will mount APIc to /apic and add in a default intializer providing examples of the route matching and authentication filtering.

```
config/initializers/apic.rb
```

#### Route Matching

APIc will load all routes in your rails app by default under the assumption that you are building your api as a dedicated service.
If this is not the case, you can specify a matching regular expression that APIc will use to find your API routes.

For example, if you have namespecs all of your api endpoints to /api/v1/ simply uncomment out the Apic.routes_matcher line in config/initializers/apic.rb

```
Apic.route_matcher = /\/api\/v1\//
```

#### Authentication filters

When testing your API it is often convenient to know which routes require authentication as you will need to add those headers before sending your request.
If you specify in your configuration the before_filter you are using for authentication APIc will mark those routes as restricted.

```
Apic.authentication_filter = :authenticate
```

## Requirements

APIc _should_ work on any Rails 3.2+ application out of the box.
If it doesn't, send me a pull request!!

## Roadmap

APIc is still in the very early days. I've gone with greater developer (as in me!) productivity at the cost of more dependencies
in the gem. Moving forward, I'd like to see the following:

- Rebuild views with vanilla erb so I can drop slim-rails
- Find someone who rocks at css/design and ditch bootstrap/sass
- Rewrite the jquery plugins in vanilla js so I can drop jquery and coffee

Under the 'fun' section comes

- Implement OAuth and Basic authentication as well as token caching
- Collect and display response time metrics
- Spec and Doc the crap out of it!

I guess when all that is done, APIc goes to 1.0.0

# Contribute

Just Do It!

This project rocks and uses MIT-LICENSE.
