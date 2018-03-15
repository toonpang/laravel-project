{% from "mongodb/map.jinja" import host_lookup as config with context %}

# Create mongodb config file using template
/etc/mongod.conf:
  file.managed:
    - source: salt://mongodb/files/mongod.conf
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'

# Setup replica set keyfile if replication == true
{% if config.mongodb.use_keyfile == 'true' %}

{{ config.mongodb.security_keyfile }}:
  file.managed:
    - contents_pillar: mongodb:lookup:mongodb:keyfile_contents
    - owner: mongod
    - group: mongod
    - mode: '0600'
    - makedirs: True
    {% if config.mongodb.restart_service_after_state_change == 'true' %}
    - watch_in:
      - service: service-mongod
    {% endif %}

{% endif %}