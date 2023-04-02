RSpec.describe Llama::Model do
  subject(:model) { Llama::Model.new("models/7B/ggml-model-q4_0.bin", seed: 2) }

  it "predicts text" do
    expect(
      model.predict("The most common words for testing a new programming language are: h", n_predict: 2)
    ).to eq(
      "The most common words for testing a new programming language are: hmmm"
    )
  end
end
