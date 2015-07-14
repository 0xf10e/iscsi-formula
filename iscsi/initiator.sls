{% from 'iscsi/default.jinja' import initiator_defaults -%}
/etc/iscsi.conf:
    file.managed:
        - source: salt://iscsi/files/iscsi.conf
        - template: jinja
        - user: root
        - group: wheel
        - mode: 640

iscsid:
{% if salt['pillar.get']('iscsi-initiator:enabled',
                        initiator_defaults['enabled']) %}
    service.running:
        - enable: True
        - require:
            - file: /etc/iscsi.conf
            - sysrc: iscsictl_flags
        - watch: 
            - file: /etc/iscsi.conf
            - sysrc: iscsictl_flags
{% else %}
    service.disabled
{% endif %}

iscsictl_flags:
{% if salt['pillar.get']('iscsi-initiator:auto_connect',
                        initiator_defaults['auto_connect']) %}
    sysrc.managed:
        - value: '-aA'
{% else %}
    sysrc:
        - absent
{% endif %}
