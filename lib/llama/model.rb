require "tempfile"

module Llama
  class Model
    # move methods defined in `model.cpp` from public to private
    private :initialize_cpp, :predict_cpp

    def self.new
      instance = allocate
      instance.send(:initialize)

      instance.send(:capture_stderr) do
        instance.send(:initialize_cpp)
      end

      instance
    end

    def predict(prompt)
      text = ""

      capture_stderr { text = predict_cpp(prompt) }

      text = text.force_encoding(Encoding.default_external)

      # remove the space that was added as a tokenizer hack in model.cpp
      text[0] = "" if text.size > 0
      text
    end

    private

    attr_reader :stderr

    def capture_stderr
      previous = STDERR.dup
      tmp = Tempfile.open("llama-rb-stderr")

      begin
        STDERR.reopen(tmp)

        yield

        tmp.rewind
        @stderr = tmp.read
      ensure
        tmp.close(true)
        STDERR.reopen(previous)
      end
    end
  end
end
