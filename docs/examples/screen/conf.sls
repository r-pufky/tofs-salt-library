# -*- coding: utf-8 -*-
# vim: ft=salt

include:
  - screen

{%- from "screen/map.jinja" import screen with context -%}
{%- import "screen/lib.jinja" as tofs with context %}

{{ screen.config }}:
  file.managed:
    - template: jinja
    - source: {{ tofs.files_switch('screen', ['/etc/screenrc', '/etc/screenrc.jinja']) }}
    - mode: 0644
    - user: root
    - group: root
