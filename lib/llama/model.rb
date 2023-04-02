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
      capture_stderr { predict_cpp(prompt) }
    end

    private

    attr_reader :stderr

    def capture_stderr
      previous = STDERR.dup
      tmp = Tempfile.open("llama-rb-stderr")
      result = nil

      begin
        STDERR.reopen(tmp)

        result = yield

        tmp.rewind
        @stderr = tmp.read
      ensure
        tmp.close(true)
        STDERR.reopen(previous)
      end

      result
    end
  end
end
