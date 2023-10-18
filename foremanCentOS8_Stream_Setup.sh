#!/bin/bash


hammer organization create --name halibelv2.local
hammer location create --name halibelATX

hammer location add-organization --name halibelATX --organization halibelv2.local

hammer sync-plan create --name 'Weekly_Sync' --interval weekly --enabled true --organization 'halibelv2.local' --sync-date '2021-01-27 10:00:00'

 wget https://www.centos.org/keys/RPM-GPG-KEY-CentOS-Official
hammer content-credential create --organization 'halibelv2.local' --key 'RPM-GPG-KEY-CentOS-Official' --name 'RPM-GPG-KEY-CentOS-8' --content-type gpg_key

hammer product create --name 'CentOS8_Stream' --organization 'halibelv2.local' --description 'CentOS 8 Repos ' --gpg-key 'RPM-GPG-KEY-CentOS-8' --sync-plan 'Weekly_Sync'

repos = ["BaseOS""AppStream""PowerTools""centosplus""extras"]

for repoid in $repos; do
  hammer repository create --organization 'halibelv2.local' --product 'CentOS8_Stream' --name 'CentOS 8 ${repoid}' --label 'CentOS8_Stream_{$repoid}' --content-type 'yum' --download-policy 'on_demand' --gpg-key 'RPM-GPG-KEY-CentOS-8' \
    --url 'http://mirror.centos.org/centos/8-stream/$(repoid)/x86_64/os/' --mirror-on-sync'no '

  for repoid in $(seq 1 5);do
    hammer repository synchronize --async --organization 'halibelv2.local' --product 'CentOS8_Stream' --id "$repoid"; done

wget https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-8

hammer content-credentials create --organization 'halibelv2.local' --key 'RPM-GPG-KEY-EPEL-8' --content-type gpg_key

hammer product create --name 'EPEL8' --organization 'halibelv2.local' --description 'Epel 8 Repos ' --gpg-key 'RPM-GPG-KEY-EPEL-8' --sync-plan 'Weekly_Sync'
                                                             

hammer repository create --organization 'halibelv2.local' --product 'EPEL8' --name 'EPEL8' --lbel 'EPEL8' --content-type 'yum'  --download-policy 'on_demand' --gpg-key 'RPM-GPG-KEY-EPEL-8' --url 'https://dl.fedoraproject.org/pub/epel/8/Everything/x86_64' --mirror-on-sync 'no'

hammer repository synchronize --async --organization 'halibelv2.local' --product 'CentOS8_Stream' --id 6

hammer content-view create --organization halibelv2.local --name 'CentOS8_Stream_CV' --description 'CentOS 8 Stream Content View'  

for i in $seq( 2 6); do hammer content-view add-repository --organization halibelv2.local --name CentOS8_Stream_CV --product CentOS8_Stream --repository-id "$i"; done

hammer content-view add-repository --organization halibelv2.local --name CentOS8_Stream_CV --product 'EPEL8' --repository-id "6" 


hammer content-view publish --organization halibelv2.local --name CentOS8_Stream_CV --description "Publishing first CentOS8 CV"  


hammer lifecycle-environment list --organization halibelv2.local

hammer activation-key create --organization halibelv2.local --name 'CentOS8_Stream_Key' --description 'CentOS 8 Stream Activation Key'  --lifecycle-environement Library --content-view CentOS8_CV --unlimited-hosts

hammer activation-key list --organization halibelv2.local


hammer activation-key add-subscription --organization halibelv2.local --name 'CentOS8_Stream_Key' --quantity '1' --subscription-id 1                                                                                                    
hammer activation-key add-subscription --organization halibelv2.local --name 'CentOS8_Stream_Key' --quantity '1' --subscription-id 4 

                                                                                             
