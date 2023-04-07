RSpec.describe Llama::Model do
  subject(:model) { described_class.new('models/7B/ggml-model-q4_0.bin', seed: 5, **params) }

  let(:params) { {} }

  it 'predicts text' do
    expect(
      model.predict('test'),
    ).to include(
      "test 3 7/12/18\nIn Reply to: test 3 posted by test on July 04, 2018 at 19:05:16:",
    )
  end

  context 'with all supported flags' do
    let(:params) do
      {
        n_predict: 3,
        threads: 8,
        top_k: 41,
        top_p: 0.8,
        repeat_last_n: 63,
        repeat_penalty: 1.2,
        ctx_size: 511,
        ignore_eos: true,
        memory_f32: true,
        temp: 0.9,
        n_parts: 10,
        batch_size: 7,
        keep: -1,
        mlock: true,
      }
    end

    it 'predicts text' do
      expect(
        model.predict('hello, wo'),
      ).to eq(
        'hello, woofs!',
      )
    end
  end
end
