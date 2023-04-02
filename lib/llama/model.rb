require 'tempfile'

module Llama
  class Model
    # move methods defined in `model.cpp` from public to private
    private :initialize_cpp, :predict_cpp

    # rubocop:disable Metrics/MethodLength
    def self.new(
      model,               # path to model file, e.g. "models/7B/ggml-model-q4_0.bin"
      n_ctx: 512,          # context size
      n_parts: -1,         # amount of model parts (-1 = determine from model dimensions)
      seed: Time.now.to_i, # RNG seed
      memory_f16: true,    # use f16 instead of f32 for memory kv
      use_mlock: false     # use mlock to keep model in memory
    )
      instance = allocate

      instance.instance_eval do
        initialize

        @model = model
        @n_ctx = n_ctx
        @n_parts = n_parts
        @seed = seed
        @memory_f16 = memory_f16
        @use_mlock = use_mlock

        capture_stderr do
          initialize_cpp(
            model,
            n_ctx,
            n_parts,
            seed,
            memory_f16,
            use_mlock,
          )
        end
      end

      instance
    end
    # rubocop:enable Metrics/MethodLength

    def predict(
      prompt,        # string used as prompt
      n_predict: 128 # number of tokens to predict
    )
      text = ''

      capture_stderr { text = predict_cpp(prompt, n_predict) }

      process_text(text)
    end

    attr_reader :model, :n_ctx, :n_parts, :seed, :memory_f16, :use_mlock, :stderr

    private

    def capture_stderr
      previous = $stderr.dup
      tmp = Tempfile.open('llama-rb-stderr')

      begin
        $stderr.reopen(tmp)

        yield

        tmp.rewind
        @stderr = tmp.read
      ensure
        tmp.close(true)
        $stderr.reopen(previous)
      end
    end

    def process_text(text)
      text = text.force_encoding(Encoding.default_external)
      # remove the space that was added as a tokenizer hack in model.cpp
      text[0] = '' if text.size.positive?

      text
    end
  end
end
