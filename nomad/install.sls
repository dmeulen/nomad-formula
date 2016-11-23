{% from "nomad/map.jinja" import nomad with context %}

nomad-dep-unzip:
  pkg.installed:
    - name: unzip

nomad-bin-dir:
  file.directory:
    - name: /usr/local/bin
    - makedirs: True

nomad-config-dir:
  file.directory:
    - name: /etc/nomad.d
    - user: root
    - group: root

nomad-runtime-dir:
  file.directory:
    - name: /var/lib/nomad
    - user: root
    - group: root

nomad-download:
  file.managed:
    - name: /tmp/nomad_{{ nomad.version }}_linux_amd64.zip
    - source: https://releases.hashicorp.com/nomad/{{ nomad.version }}/nomad_{{ nomad.version }}_linux_amd64.zip
    - source_hash: sha256={{ nomad.hash }}
    - unless: test -f /usr/local/bin/nomad-{{ nomad.version }}

nomad-extract:
  cmd.wait:
    - name: unzip /tmp/nomad_{{ nomad.version }}_linux_amd64.zip -d /tmp
    - watch:
      - file: nomad-download

nomad-install:
  file.rename:
    - name: /usr/local/bin/nomad-{{ nomad.version }}
    - source: /tmp/nomad
    - require:
      - file: /usr/local/bin
    - watch:
      - cmd: nomad-extract

nomad-clean:
  file.absent:
    - name: /tmp/nomad_{{ nomad.version }}_linux_amd64.zip
    - watch:
      - file: nomad-install

nomad-link:
  file.symlink:
    - target: nomad-{{ nomad.version }}
    - name: /usr/local/bin/nomad
    - watch:
      - file: nomad-install