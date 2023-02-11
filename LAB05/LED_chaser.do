radix symbolic
force fast_clock 0 0ns, 1 20ns -r 40ns
force rst 1
force mode 0
run 5000ns
force mode 1
run 5000ns
force rst 0
run 600ns