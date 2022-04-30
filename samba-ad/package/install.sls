# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as samba__ad with context %}

samba-ad-package-install-pkg-installed:
  pkg.installed:
    - name: {{ samba__ad.pkg.name }}
