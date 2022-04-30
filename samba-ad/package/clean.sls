# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as samba__ad with context %}

include:
  - {{ sls_config_clean }}

samba-ad-package-clean-pkg-removed:
  pkg.removed:
    - name: {{ samba__ad.pkg.name }}
    - require:
      - sls: {{ sls_config_clean }}
