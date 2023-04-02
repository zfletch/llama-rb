#include <rice/rice.hpp>

#include "common.h"
#include "llama.h"

#include <cassert>
#include <cinttypes>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

Rice::Object session_test(Rice::Object /* self */, const char *prompt)
{
	std::string return_val = "";

    gpt_params params;
    params.model = "models/7B/ggml-model-q4_0.bin"; // TODO: remove
	params.prompt = prompt;

    llama_context *ctx;

    // load the model
    {
        auto lparams = llama_context_default_params();

        lparams.n_ctx      = params.n_ctx;
        lparams.n_parts    = params.n_parts;
        lparams.seed       = params.seed;
        lparams.f16_kv     = params.memory_f16;
        lparams.use_mlock  = params.use_mlock;

        ctx = llama_init_from_file(params.model.c_str(), lparams);

        if (ctx == NULL) {
            fprintf(stderr, "%s: error: failed to load model '%s'\n", __func__, params.model.c_str());

            return NULL;
        }
    }

    // add a space in front of the first character to match OG llama tokenizer behavior
    params.prompt.insert(0, 1, ' ');

    // tokenize the prompt
    auto embd_inp = ::llama_tokenize(ctx, params.prompt, true);
    const int n_ctx = llama_n_ctx(ctx);

    // determine newline token
    auto llama_token_newline = ::llama_tokenize(ctx, "\n", false);

	// generate output
	{
		std::vector<llama_token> last_n_tokens(n_ctx);
		std::fill(last_n_tokens.begin(), last_n_tokens.end(), 0);

		int n_past     = 0;
		int n_remain   = params.n_predict;
		int n_consumed = 0;

		std::vector<llama_token> embd;

		while (n_remain != 0) {
			if (embd.size() > 0) {
				// infinite text generation via context swapping
				// if we run out of context:
				// - take the n_keep first tokens from the original prompt (via n_past)
				// - take half of the last (n_ctx - n_keep) tokens and recompute the logits in a batch
				if (n_past + (int) embd.size() > n_ctx) {
					const int n_left = n_past - params.n_keep;

					n_past = params.n_keep;

					// insert n_left/2 tokens at the start of embd from last_n_tokens
					embd.insert(embd.begin(), last_n_tokens.begin() + n_ctx - n_left/2 - embd.size(), last_n_tokens.end() - embd.size());
				}

				if (llama_eval(ctx, embd.data(), embd.size(), n_past, params.n_threads)) {
					fprintf(stderr, "%s : failed to eval\n", __func__);

					return NULL;
				}
			}


			n_past += embd.size();
			embd.clear();

			if ((int) embd_inp.size() <= n_consumed) {
				// out of user input, sample next token
				const int32_t top_k          = params.top_k;
				const float   top_p          = params.top_p;
				const float   temp           = params.temp;
				const float   repeat_penalty = params.repeat_penalty;

				llama_token id = 0;

				{
					auto logits = llama_get_logits(ctx);

					if (params.ignore_eos) {
						logits[llama_token_eos()] = 0;
					}

					id = llama_sample_top_p_top_k(ctx,
							last_n_tokens.data() + n_ctx - params.repeat_last_n,
							params.repeat_last_n, top_k, top_p, temp, repeat_penalty);

					last_n_tokens.erase(last_n_tokens.begin());
					last_n_tokens.push_back(id);
				}

				// replace end of text token with newline token when in interactive mode
				if (id == llama_token_eos() && params.interactive && !params.instruct) {
					id = llama_token_newline.front();
					if (params.antiprompt.size() != 0) {
						// tokenize and inject first reverse prompt
						const auto first_antiprompt = ::llama_tokenize(ctx, params.antiprompt.front(), false);
						embd_inp.insert(embd_inp.end(), first_antiprompt.begin(), first_antiprompt.end());
					}
				}

				// add it to the context
				embd.push_back(id);

				// decrement remaining sampling budget
				--n_remain;
			} else {
				// some user input remains from prompt or interaction, forward it to processing
				while ((int) embd_inp.size() > n_consumed) {
					embd.push_back(embd_inp[n_consumed]);
					last_n_tokens.erase(last_n_tokens.begin());
					last_n_tokens.push_back(embd_inp[n_consumed]);
					++n_consumed;
					if ((int) embd.size() >= params.n_batch) {
						break;
					}
				}
			}

            for (auto id : embd) {
				return_val += llama_token_to_str(ctx, id);
            }
		}
	}

	// free memory
    llama_free(ctx);

	Rice::String ruby_return_val(return_val);
	return ruby_return_val;
}

Rice::Object session_hello(Rice::Object /* self */)
{
	Rice::String str("hello world");

	return str;
}

extern "C"
void Init_session()
{
	Rice::Module rb_mLlama = Rice::define_module("Llama");
	Rice::Class rb_cSession =
		define_class_under(rb_mLlama, "Session");

	rb_cSession.define_method("hello", &session_hello);
	rb_cSession.define_method("test", &session_test);
}
