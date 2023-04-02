module Llama
  class Model
    # move methods defined in `model.cpp` from public to private
    private :initialize_cpp, :predict_cpp

    def self.new
      instance = allocate
      instance.send(:initialize)
      instance.send(:initialize_cpp)

      instance
    end

    def predict(prompt)
      predict_cpp(prompt)
    end
  end
end
