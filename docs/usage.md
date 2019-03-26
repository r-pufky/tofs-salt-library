dir_switch
==========
Return valid single directories for 'source' parameter using TOFS pattern.

Params:
  prefix: String pillar prefix to custom :dir_switch. Colons (:) are are
      replaced by forward slash (/) to be used as directory prefix.
  target: String full path directory to manage. This should appear as it would
      on the target system (e.g. /etc/skel).
  default_rank: List of Strings to use as keys to search grains for most
      specific match of a host to a subdiretory. Only used if no pillar
      prefix:dir_switch exists. Default: ['id', 'os', 'os_family'].
  indent_width: Integer ndentation of the result value to conform to YAML.
      Default: 6.

Examples:
  If we have a state:
    my_state:
      file.recurse:
        - source: {{ dir_switch('formula_name', ['/etc/skel']) }}

  It will return the first matching directory using the most specific match,
  using the default config if no match: pillar > os > os_family > default.

Specific host:
  In a minion with id=theminion and os_family=RedHat, and called as:

  - source: {{ dir_switch('formula_name', ['/etc/skel']) }}

  It will be rendered as:

  my_state:
    file.recurse:
      - source: salt://formual_name/files/theminion/etc/skel/

Apply for all hosts in OS Family.
  In a minion with id=tacotruck and os_family=RedHat, and called as:

  - source: {{ dir_switch('formula_name', ['/etc/skel']) }}

  It will be rendered as:

  my_state:
    file.recurse:
      - source: salt://formula_name/files/RedHat/etc/skel/

Default value (no matching pillar, os, os_family).
  In a minion with id=tacotruck and os_family=RedHat, and called as:

  - source: {{ dir_switch('formula_name', ['/etc/skel']) }}

  It will be rendered as:

  my_state:
    file.recurse:
      - source: salt://formula_name/files/default/etc/skel/

files_switch
============
Returns a valid value for the "source" parameter of a "file.managed"
state function. This makes easier the usage of the Template Override and
Files Switch (TOFS) pattern.

Params:
  * prefix: pillar prefix to custom ':files_switch'. Colons ':'
    are replaced by '/' to be used as directory prefix
  * files: ordered list of files to look for, with full path
  * default_files_switch: if there's no pillar 'prefix:files_switch'
    this is the ordered list of grains to use as selector switch of the
    directories under "prefix/files"
  * indent_witdh: indentation of the result value to conform to YAML

Example:

If we have a state:

  /etc/xxx/xxx.conf:
    file:
      - managed
      - source: {{ files_switch('xxx', ['/etc/xxx/xxx.conf',
                                        '/etc/xxx/xxx.conf.jinja']) }}
      - template: jinja

In a minion with id=theminion and os_family=RedHat, it's going to be
rendered as:

  /etc/xxx/xxx.conf:
    file:
      - managed
      - source:
        - salt://xxx/files/theminion/etc/xxx/xxx.conf
        - salt://xxx/files/theminion/etc/xxx/xxx.conf.jinja
        - salt://xxx/files/RedHat/etc/xxx/xxx.conf
        - salt://xxx/files/RedHat/etc/xxx/xxx.conf.jinja
        - salt://xxx/files/default/etc/xxx/xxx.conf
        - salt://xxx/files/default/etc/xxx/xxx.conf.jinja

key_value_formatter
==================
Returns a key:value pair with a space between. Lists will automatically
be rendered with the same key for each list item.

Params:
  * key: The config keyword to render
  * value: The data for the keyword

Example 1:
  bind:
    - ^k
    - ^\

  key_value_formatter('bind', ['^k', '^\']) would render as:
    bind ^k
    bind ^\

Example 2:
  startup_message: on

  key_value_formatter('startup_message', 'on') would render as:
    startup_message on