require 'fileutils'

root = File.dirname(__FILE__)
llama_root = File.join(root, '..', 'llama.cpp')

main = File.join(root, '..', 'bin', 'llama')
llama_main = File.join(llama_root, 'main')

Dir.chdir(llama_root) { system('make main', exception: true) }
FileUtils.cp(llama_main, main)
