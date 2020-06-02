# Computer-Systems-Lab-4
Contains GAS Assembly code for x86-64 architecture for three simple programs:

* exit.s does nothing (small example of a compilable program)
* samduren.s reports to stdout all command-line arguments (argv) with which it's called ("Sam duren'!" in Ukrainian means, roughly, "The same to you!", which succinctly describes this program's behaviour from the perspective of a terminal user)
* envtruth.s outputs to stdout environment variables as found in the process' address space. Output of this program is compared with that of the standard shell command 'env' (envtruth.txt and env.txt respectively)
