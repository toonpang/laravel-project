# Install mongodb from a package

{% set pip_pkg_name = {
    'Amazon': 'python26-pip',
    'CentOS': 'python2-pip',
}.get(grains.os) %}

{% set pip_cmd = {
    'Amazon': 'pip-2.6',
    'CentOS': 'pip',
}.get(grains.os) %}

package-install-mongodb:
  pkg.installed:
    - pkgs:
      - epel-release   # Base install
      - policycoreutils-python   # Base install
      - numactl
      - mongodb-org
    - refresh: True
    - require:
      - file: /etc/yum.repos.d/MongoDB-3.6.repo

# Install pip
pip-install-mongodb:
  pkg.installed:
    - pkgs:
      - {{ pip_pkg_name }}
    - refresh: True
    - reload_modules: True
    - require:
      - pkg: package-install-mongodb

# Upgrade older versions of pip
pip-upgrade-mongodb:
  cmd.run:
    - name: {{ pip_cmd }} install --upgrade pip
    - onlyif: {{ pip_cmd }} list --outdated --format=legacy |grep pymongo
    - require:
      - pkg: pip-install-mongodb

# This is needed for mongodb_* states to work in the same Salt job
pip-package-install-pymongo:
  pip.installed:
    - name: pymongo
    - reload_modules: True
    {% if grains.os == 'Amazon' %}
    - cwd: '/usr/bin'
    - bin_env: '/usr/bin/pip-2.6'
    {%- endif %}
    - require:
      - pkg: package-install-mongodb
      - cmd: pip-upgrade-mongodb