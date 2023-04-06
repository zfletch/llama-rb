RSpec.describe Llama::Model do
  subject(:model) { described_class.new('models/7B/ggml-model-q4_0.bin', seed: 10, n_predict: 1) }

  it 'predicts text' do
    expect(
      model.predict('hello, wo'),
    ).to eq(
      'hello, woof',
    )
  end
end
