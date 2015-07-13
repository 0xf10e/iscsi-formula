{% from 'iscsi/defaults.jinja' import target_defaults %}

/etc/ctl.conf:
    file.managed:
        source: salt://iscsi/files/ctl.conf
        template: jinja
        user: root
        group: wheel
        mode: 644

ctld:
    service.running:
        enabled: {{ salt['pillar.get']('iscsi-targets:enabled',
                        target_defaults.enabled) }}
        require:
            - file: /etc/ctl.conf
        watch:
            - file: /etc/ctl.conf
