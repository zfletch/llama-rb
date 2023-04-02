require "mkmf-rice"

# Compile llama.cpp
# root = File.expand_path(File.join(File.dirname(__FILE__), "..", ".."))
# llama_cpp = File.join(root, 'llama.cpp')
#
# Dir.chdir(llama_cpp) do
#   system("make", exception: true)
# end

# Create Makefile for Ruby bindings
create_makefile "llama/model"
