{% from "nomad/map.jinja" import nomad with context %}

nomad-init-file:
  file.managed:
    {%- if salt['test.provider']('service') == 'systemd' %}
    - source: salt://nomad/files/nomad.service
    - name: /etc/systemd/system/consul.service
    - mode: 0644
    {%- elif salt['test.provider']('service') == 'upstart' %}
    - source: salt://nomad/files/nomad.upstart
    - name: /etc/init/nomad.conf
    - mode: 0644
    {%- else %}
    - source: salt://nomad/files/nomad.sysvnit
    - name: /etc/init.d/nomad
    - mode: 0755
    {%- endif %}

{%- if nomad.service %}

nomad-service:
  service.running:
    - name: nomad
    - enabled: True
    - watch:
      - file: nomad-init-file

{%- endif %}