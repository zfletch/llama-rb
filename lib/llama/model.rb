require 'open3'
require 'shellwords'

module Llama
  class Model
    class ModelError < StandardError
    end

    def initialize(
      model,
      seed: Time.now.to_i,
      n_predict: 128,
      binary: default_binary
    )
      @model = model
      @seed = seed
      @n_predict = n_predict
      @binary = binary
    end

    def predict(prompt)
      stdout, @stderr, @status = Open3.capture3(command(prompt))

      raise ModelError, "Error #{status.to_i}" unless status.success?

      # remove the space that is added as a tokenizer hack in examples/main/main.cpp
      stdout[0] = ''
      stdout
    end

    attr_reader :model, :seed, :n_predict, :binary

    private

    attr_reader :stderr, :status

    def default_binary
      File.join(File.dirname(__FILE__), '..', '..', 'bin', 'llama')
    end

    def command(prompt)
      escape_command(binary,
        model: model,
        prompt: prompt,
        seed: seed,
        n_predict: n_predict)
    end

    def escape_command(command, **flags)
      flags_string = flags.map do |key, value|
        "--#{Shellwords.escape(key)} #{Shellwords.escape(value)}"
      end.join(' ')
      command_string = Shellwords.escape(command)

      "#{command_string} #{flags_string}"
    end
  end
end
