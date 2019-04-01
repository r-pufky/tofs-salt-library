TOFS Lib Usage
==============
Detailed method usage instructions.

* See [screen example](examples/screen/) for files_switch/key_value_formatter
  specific examples.
* See [skel example](examples/skel/) for dir_switch specific example.

### Import TOFS lib for usage
Import the library and use the macros below.

```jinja
{%- import "skel/lib.jinja" as tofs with context %}
```


dir_switch
----------
Return valid single directories for 'source' parameter using TOFS pattern.

| Args         | Purpose                                                                                                                                                                                  |
|--------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| prefix       | String pillar prefix to custom :dir_switch. Colons (:) are are replaced by forward slash (/) to be used as directory prefix.                                                             |
| target       | String full path directory to manage. This should appear as it would on the target system (e.g. /etc/skel).                                                                              |
| default_rank | List of Strings to use as keys to search grains for most specific match of a host to a subdiretory. Only used if no pillar prefix:dir_switch exists. Default: ['id', 'os', 'os_family']. |
| indent_width | Integer ndentation of the result value to conform to YAML. Default: 6.                                                                                                                   |

If we have a state:
```jinja
    my_state:
      file.recurse:
        - source: {{ dir_switch('formula_name', ['/etc/skel']) }}
```

It will return the first matching directory using the most specific match, using
the default config if no match: `pillar > os > os_family > default`.

### Specific host
In a minion with id=theminion and os_family=RedHat, and called as:

```jinja
  - source: {{ dir_switch('formula_name', ['/etc/skel']) }}
```

It will be rendered as:
```jinja
  my_state:
    file.recurse:
      - source: salt://formual_name/files/theminion/etc/skel/
```

### Apply for all hosts in OS Family

In a minion with id=tacotruck and os_family=RedHat, and called as:
```jinja
  - source: {{ dir_switch('formula_name', ['/etc/skel']) }}
```

It will be rendered as:
```jinja
  my_state:
    file.recurse:
      - source: salt://formula_name/files/RedHat/etc/skel/
```

### Default value (no matching pillar, os, os_family).
In a minion with id=tacotruck and os_family=RedHat, and called as:

```jinja
  - source: {{ dir_switch('formula_name', ['/etc/skel']) }}
```

It will be rendered as:
```jinja
  my_state:
    file.recurse:
      - source: salt://formula_name/files/default/etc/skel/
```

files_switch
------------
Return valid list of 'source' parameters using TOFS pattern.

| Args         | Purpose                                                                                                                                                                                             |
|--------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| prefix       | String pillar prefix to custom :files_switch. Colons (:) are replaced by forward slash (/) to be used as directory prefix.                                                                          |
| files        | Ordered List of Strings containing full path of files to look for.                                                                                                                                  |
| default_rank | Ordered List of Strings to use as keys to search grains for most specific match of a host to a subdirectory. Only used if no pillar prefix:files_switch exists. Default: ['id', 'os', 'os_family']. |
| indent_width | Integer indentation of the result value to conform to YAML. Default: 6.                                                                                                                             |

If we have a state:

```jinja
/etc/xxx/xxx.conf:
  file:
    - managed
    - source: {{ files_switch('xxx', ['/etc/xxx/xxx.conf',
                                      '/etc/xxx/xxx.conf.jinja']) }}
    - template: jinja
```

In a minion with id=theminion and os_family=RedHat, it will be rendered as:

```jinja
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
```

key_value_formatter
-------------------
Return key:value pair using a space separator.

Lists will automatically be rendered with the same key for each list item.

| Args  | Purpose                          |
|-------|----------------------------------|
| key   | String config keyword to render. |
| value | Object data for the keyword.     |

### Example 1

```yaml
bind:
  - ^k
  - ^\
```

`key_value_formatter('bind', ['^k', '^\'])` would render as:
```jinja
bind ^k
bind ^\
```

### Example 2

```yaml
startup_message: on
```

`key_value_formatter('startup_message', 'on')` would render as:
```jinja
startup_message on
```
