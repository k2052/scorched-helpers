# The place of description and intro. Human meet scorched-helpers. 

scorched-helpers is a collection of helpers for the [Scorched](https://github.com/Wardrop/Scorched) framework. 
Most of the code is based on/ported from sinatra_more and padrino-helpers. At the moment it provides tag helpers, translation helpers and asset helpers

# Installation/Usage

For the the time being you need to use my fork of Scorched, which adds support for extensions to Scorched.

Just add the following to your Gemfile

```ruby
gem 'scorched',         git: 'https://github.com/bookworm/Scorched.git'
gem 'scorched-helpers', git: 'https://github.com/bookworm/scorched-helpers.git'
```

It's a good idea to pick a commit ID and specify it in your Gemfile in case I commit broken changes to master.

```ruby
gem 'scorched', git: 'https://github.com/bookworm/Scorched.git', ref: '7e4faf7aea36151c9414480d929104fa0525d325'
```

Adding the extension is fairly simple and should be familiar to you if have used Sinatra or Padrino.

```ruby
require 'scorched-helpers'
class App < Scorched::Controller
  register ScorchedHelpers
end
run App
```

After that you'll have helpers available in your template files. Dig over the specs for some usage examples.
