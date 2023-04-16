require 'open3'
require 'shellwords'

module Llama
  class Model
    class ModelError < StandardError
    end

    def initialize(
      model,
      binary: default_binary,
      seed: Time.now.to_i,
      n_predict: nil,
      threads: nil,
      top_k: nil,
      top_p: nil,
      repeat_last_n: nil,
      repeat_penalty: nil,
      ctx_size: nil,
      ignore_eos: nil,
      memory_f32: nil,
      temp: nil,
      n_parts: nil,
      batch_size: nil,
      keep: nil,
      mlock: nil
    )
      @model = model
      @seed = seed
      @n_predict = n_predict
      @binary = binary
      @threads = threads
      @top_k = top_k
      @top_p = top_p
      @repeat_last_n = repeat_last_n
      @repeat_penalty = repeat_penalty
      @ctx_size = ctx_size
      @ignore_eos = ignore_eos
      @memory_f32 = memory_f32
      @temp = temp
      @n_parts = n_parts
      @batch_size = batch_size
      @keep = keep
      @mlock = mlock
    end

    def predict(prompt)
      stdout, @stderr, @status = Open3.capture3(command(prompt))

      unless status.success?
        error_string = stderr.split("\n").first

        raise ModelError, "Error #{error_string}"
      end

      # remove the space that is added as a tokenizer hack in examples/main/main.cpp
      stdout[0] = ''
      stdout
    end

    attr_reader :model, :seed, :n_predict, :binary, :threads, :top_k, :top_p, :repeat_last_n,
      :repeat_penalty, :ctx_size, :ignore_eos, :memory_f32, :temp, :n_parts, :batch_size, :keep,
      :mlock

    private

    attr_reader :stderr, :status

    def default_binary
      File.join(File.dirname(__FILE__), '..', '..', 'bin', 'llama')
    end

    def command(prompt) # rubocop:disable all
      escape_command(
        binary,
        model: model,
        prompt: prompt,
        seed: seed,
        n_predict: n_predict,
        threads: threads,
        top_k: top_k,
        top_p: top_p,
        repeat_last_n: repeat_last_n,
        repeat_penalty: repeat_penalty,
        ctx_size: ctx_size,
        'ignore-eos': !!ignore_eos,
        memory_f32: !!memory_f32,
        temp: temp,
        n_parts: n_parts,
        batch_size: batch_size,
        keep: keep,
        mlock: mlock,
      )
    end

    def escape_command(command, **flags)
      flags_components = []

      flags.each do |key, value|
        if value == true
          flags_components.push("--#{Shellwords.escape(key)}")
        elsif value
          flags_components.push("--#{Shellwords.escape(key)} #{Shellwords.escape(value)}")
        end
      end

      command_string = Shellwords.escape(command)
      flags_string = flags_components.join(' ')

      "#{command_string} #{flags_string}"
    end
  end
end
