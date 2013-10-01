= Apic

[![Build Status](https://secure.travis-ci.org/hsbt/whispered.png)](https://travis-ci.org/hsbt/whispered) [![Coverage Status](https://coveralls.io/repos/randym/apic/badge.png?branch=master)](https://coveralls.io/r/randym/apic) [![Dependency Status](https://gemnasium.com/randym/apic.png)](https://gemnasium.com/randym/apic) [![Code Climate](https://codeclimate.com/github/randym/apic.png)](https://codeclimate.com/github/randym/apic)

![Screen 1](https://github.com/randym/apic/raw/master/sample.png)

What you need to do?

add the gem to your Gemfile

```
gem 'apic'
```

require the gem in your application.rb

```
require 'apic'
```

mount the gem in your routes.rb

```
mount Apic::Engine, :at => "/apic"
```

## and some groovy stuff too

Specify action paramters in your api controllers

```
apic_action_params create: [:name, :acceptance]
```

Filter routes on a regex match


```
Apic.routes_matcher = /\/api\//
```

Tell us what your authorization filter is!

```
Apic.authorization_filter = :authenticate
```

This project rocks and uses MIT-LICENSE.
