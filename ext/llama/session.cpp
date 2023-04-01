#include <rice/rice.hpp>

using namespace Rice;

Object session_hello(Object /* self */)
{
	String str("hello world");
	return str;
}

extern "C"
void Init_session()
{
	Module rb_mLlama = define_module("Llama");
	Class rb_cSession =
		define_class_under(rb_mLlama, "Session");

	rb_cSession.define_method("hello", &session_hello);
}
