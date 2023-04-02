# Llama-rb

Ruby wrapper for
[llama.cpp](https://github.com/ggerganov/llama.cpp).

This was hacked together in a weekend and versions `0.x.x` should be considered unstable. 

## Installation

Install the gem and add to the application's Gemfile by executing:

```
$ bundle add llama-rb
```

If bundler is not being used to manage dependencies, install the gem by executing:

```
$ gem install llama-rb
```

## Usage

### Models

Before using this code, you will need to download and process at least one. See
[ggerganov/llama.cpp](https://github.com/ggerganov/llama.cpp#obtaining-and-verifying-the-facebook-llama-original-model-and-stanford-alpaca-model-data).

### Example

```ruby
require 'llama'

m = Llama::Model.new('models/7B/ggml-model-q4_0.bin')
m.predict('hello world')
```

### API

#### Llama::Model.new

```ruby
def self.new(
  model,               # path to model file, e.g. "models/7B/ggml-model-q4_0.bin"
  n_ctx: 512,          # context size
  n_parts: -1,         # amount of model parts (-1 = determine from model dimensions)
  seed: Time.now.to_i, # RNG seed
  memory_f16: true,    # use f16 instead of f32 for memory kv
  use_mlock: false     # use mlock to keep model in memory
)
```

#### Llama::Model#predict

```ruby
def predict(
  prompt,        # string used as prompt
  n_predict: 128 # number of tokens to predict
)
```

## Development

```
git clone --recurse-submodules https://github.com/zfletch/llama-rb
cd llama-rb
./bin/setup
```

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push git
commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zfletch/llama-rb.
