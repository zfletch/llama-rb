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
require 'llama'

Llama::Model.new('models/7B/ggml-model-q4_0.bin')
```

Optional arguments:

```ruby
seed           # RNG seed (default Time.now.to_i)
n_predict      # number of tokens to predict (default: 128, -1 = infinity)
threads        # number of threads to use during computation (default: 4)
top_k          # top-k sampling (default: 40)
top_p          # top-p sampling (default: 0.9)
repeat_last_n  # last n tokens to consider for penalize (default: 64)
repeat_penalty # penalize repeat sequence of tokens (default: 1.1)
ctx_size       # size of the prompt context (default: 512)
ignore_eos     # ignore end of stream token and continue generating
memory_f32     # use f32 instead of f16 for memory key+value
temp           # temperature (default: 0.8)
n_parts        # number of model parts (default: -1 = determine from dimensions)
batch_size     # batch size for prompt processing (default: 8)
keep           # number of tokens to keep from the initial prompt (default: 0, -1 = all)
mlock          # force system to keep model in RAM rather than swapping or compressing
```

#### Llama::Model#predict

```ruby
model.predict('hello world')
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
