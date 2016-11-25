{% from "nomad/map.jinja" import nomad with context %}

nomad-config:
  file.serialize:
    - name: /etc/nomad.d/config.json
    - dataset: {{ nomad.config }}
    - formatter: json
