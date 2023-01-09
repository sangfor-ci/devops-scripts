#!/bin/bash

wget -c -N https://github.com/ocaml/ocaml/archive/refs/tags/4.14.0.tar.gz && \
  cd ocaml-4.14.0 && ./configure && make install


