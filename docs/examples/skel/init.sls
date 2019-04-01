{%- from "skel/map.jinja" import skel with context %}
{%- import "skel/lib.jinja" as tofs with context %}

{{ skel.location }}:
  file.recurse:
    - onlyif: test ! -f {{ skel.onlyif }}
    - source: {{ tofs.dir_switch('skel', '/etc/skel') }}
    - dir_mode: 0700
    - file_mode: 0600
    - makedirs: True
    - user: root
    - group: root
    - include_empty: {{ skel.include_empty }}
    - clean: {{ skel.clean }}
