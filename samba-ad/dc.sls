samba-ad-dc-host-only:
  host.only:
    - name: {{ grains.ip4_interfaces.eth0[0] }}
    - hostnames:
        - {{ grains.host}}.vagrant.internal
        - {{ grains.host }}

samba-ad-dc-pkg-installed:
  pkg.installed:
    - names:
        - attr
        - krb5-user
        - python3-augeas
        - samba
        - samba-dsdb-modules
        - samba-vfs-modules
        - smbclient

winbind:
  pkg.installed:
    - require:
      - pkg: samba-ad-dc-pkg-installed


provision:
  file.rename:
    - name: /etc/samba/smb.conf.salt
    - source: /etc/samba/smb.conf
    - unless: test -f /etc/samba/smb.conf.salt
    - require:
      - pkg: winbind
  cmd.run:
    - name: samba-tool domain provision --realm=vagrant.internal --domain vagrant --adminpass='w1ndow$$!'
    - creates: /var/lib/samba/private/sam.ldb
    - require:
      - file: provision
#lo:
#  network.managed:
#    - type: eth
#    - proto: loopback
#    - dns:
#      - 127.0.0.1
#    - search:
#      - vagrant.internal
#    - require:
#      - cmd: provision

samba-ad-dc-file-managed:
  file.managed:
    - name: /etc/resolv.conf
    - contents:
      - nameserver 127.0.0.1
      - search vagrant.internal

krb5-config:
  file.managed:
    - name: /etc/krb5.conf
    - source: /var/lib/samba/private/krb5.conf
    - require:
      - cmd: provision

printing-config:
  augeas.change:
    - changes:
      - set "/files/etc/samba/smb.conf/*[.=\"global\"]/printing" bsd
    - require:
      - cmd: provision


printcap-config:
  augeas.change:
    - changes:
      - set "/files/etc/samba/smb.conf/*[.=\"global\"]/printcap name" /dev/null
    - require:
      - cmd: provision

samba-ad-dc-service-dead:
  service.dead:
    - names:
      - nmbd
      - smbd
      - winbind
    - enable: false
    - require:
      - augeas: printcap-config

samba-ad-dc-service-unmasked:
  service.unmasked:
    - name: samba-ad-dc
    - require:
      - service: samba-ad-dc-service-dead

samba-ad-dc-service-running:
  service.running:
    - name: samba-ad-dc
    - enable: true
    - require:
      - service: samba-ad-dc-service-unmasked
