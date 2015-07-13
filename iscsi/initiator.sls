{% from 'iscsi/default.jinja' import initiator_defaults -%}
/etc/iscsi.conf:
    file.managed:
        - source: salt://iscsi/files/iscsi.conf
        - template: jinja
        - user: root
        - group: wheel
        - mode: 644

iscsid:
    service.running:
        - name: iscsictl
        - enable: {{ salt['pillar.get']('iscsi-initiator:enabled',
                        initiator_defaults['enabled']) }}
        - require:
            - file: /etc/iscsi.conf
        - watch: 
            - file: /etc/iscsi.conf
