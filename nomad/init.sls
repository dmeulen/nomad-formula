{% from "nomad/map.jinja" import nomad with context %}

include:
  - .install
  - .config
  - .service