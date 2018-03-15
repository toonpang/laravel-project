# Configure repo file for RHEL based systems

{% set repo_source = {
    'Amazon': 'salt://mongodb/files/amazon-mongdb-3.6.repo',
    'CentOS': 'salt://mongodb/files/redhat-mongodb-3.6.repo',
}.get(grains.os) %}

/etc/yum.repos.d/MongoDB-3.6.repo:
  file.managed:
    - source: {{ repo_source }}
    - user: root
    - group: root
    - mode: '0644'