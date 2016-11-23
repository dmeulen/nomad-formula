{% from "nomad/map.jinja" import nomad with context %}

cgroupfs-mount:
  file.managed:
    - name: /etc/init.d/cgroupfs-mount
    - source: salt://nomad/files/etc/init.d/cgroupfs-mount

nomad-config:
  file.serialize:
    - name: /etc/nomad.d/config.json
    - dataset: {{ nomad.config }}
    - formatter: json