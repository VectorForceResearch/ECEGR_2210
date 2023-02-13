radix symbolic

force clock_signal 0 0ns, 1 6ns -r 12ns
force rst 1 0ns, 0 1ns
force standby 0 0ns, 1 450ns, 0 700ns
run 1000ns