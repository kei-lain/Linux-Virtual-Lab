#!/bin/bash

#Usage: Setup script for Foreman/katello for CentOS 7


hostnamectl set-hostname halibelv2.local

 yum update -y https://fedorapeople.org/groups/katello/releases/yum/3.18/katello/el7/x86_64/katello-repos-latest.rpm
  yum update -y https://yum.theforeman.org/releases/2.3/el7/x86_64/foreman-release.rpm
  subscription-manager repos --enable=rhel-server-rhscl-7-rpms
    yum update -y https://fedorapeople.org/groups/katello/releases/yum/3.18/katello/el7/x86_64/katello-repos-latest.rpm
  yum update -y https://yum.theforeman.org/releases/2.3/el7/x86_64/foreman-release.rpm
  yum -y install https://yum.puppet.com/puppet6-release-el-7.noarch.rpm
  yum -y install epel-release centos-release-scl-rh
  yum install -y centos-release-scl-rh
  yum-config-manager --enable extras
  yum update -y 


  foreman-installer --scenario katello --foreman-intial-admin-username admin --foreman-initial-admin-password admin


  hammer organization create --name halibelv2.local
  hammer location create --name halibelATX

hammer location add-organization --name halibelATX --organization halibelv2.local

hammer sync-plan create --name 'Weekly_Sync' --interval weekly --enabled true --organization 'halibelv2.local'--sync-date '2021-01-26 10:00:00'

wget https://www.centos.org/keys/RPM-GPG-KEY-CentOS-Official
hammer content-credential create --organization 'halibelv2.local' --key 'RPM-GPG-KEY-CentOS-Official' --name 'RPM-GPG-KEY-CentOS-8' --content-type gpg_key

hammer product create --name 'CentOS8_Stream' --organization 'halibelv2.local' --description 'CentOS 8 Repos ' --gpgp-key 'RPM-GPG-KEY-CentOS-8' --sync-plan 'Weekly_sync'

repos = [BaseOS,AppStream,PowerTools,centosplus,extras]

for repoid in $repos; do
  hammer repository create --organization 'halibelv2.local' --product 'CentOS8_Stream' --name 'CentOS 8 ${repoid}' --label 'CentOS8_Stream_{$repoid}' --content-type 'yum' --download-policy 'on_demand' --gpg-key 'RPM-GPG-KEY-CentOS-8' \
    --url 'http://mirror.centos.org/centos/8-stream/$(repoid)/x86_64/os/' --mirror-on-sync'no '

  for repoid in $(seq 1 5);do
    hammer repository synchronize --async --organization 'halibelv2.local' --product 'CentOS8_Stream' --id "$repoid"; done

wget https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-8

hammer content-credentials create --organization 'halibelv2.local' --key 'RPM-GPG-KEY-EPEL-8' --content-type gpg_key 

hammer product create --name 'EPEL8' --organization 'halibelv2.local' --description 'Epel 8 Repos ' --gpg-key 'RPM-GPG-KEY-EPEL-8' --sync-plan 'Weekly_Sync'

hammer repository create --organization 'halibelv2.local' --product 'EPEL8' --name 'EPEL8' --label 'EPEL8' --content-type 'yum' --download-policy 'on_demand' --gpg-key 'RPM-GPG-KEY-EPEL-8' --url 'https://dl.fedoraproject.org/pub/epel/8/Everything/x86_64' --mirror-on-sync 'no'

hammer repository synchronize --async --organization 'halibelv2.local' --product 'CentOS8_Stream' --id 6


