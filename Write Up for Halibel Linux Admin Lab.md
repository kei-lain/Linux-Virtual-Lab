# **Prologue**

I wanted to make a homelab that emulated an enterprise linux environment using a kvm hypervisor on my home system.

For my Hypervisor I'm using KVM on ARCH Linux using Kernel 5.9-zen. I'm using Qemu which is a generic open source emulator and virutalizer. While this can use a xen hypervisor , I chose KVM because I need to run other programs on the System.

For the Enterprise Linux Environment. All Virtual Machines are running CentOS 7.2009. This is because Red Hat Enterprise Linux is one of the main Open Source Operating Systems run by many companies as well as different Government Entities in addition to its compatibility with Foreman , FreeIPA, and Katello

* * *

## **Setting up Foreman**

This guide is for implementing Foreman, a system and configuration management program. So assuming the CentOS 7 VM is created in virt-manager, we first need to check the IP Address so we can ssh into the machine.

![checkip.png](../../_resources/checkip.png)

Checking if SSH is turned on

![checkingssh.png](../../_resources/checkingssh.png)

Connecting to VM from host machine terminal

![connecttovm.png](../../_resources/connecttovm.png)

Update packages

![updatevm.png](../../_resources/updatevm.png)

Install new repo repos for Foreman:
`yum -y localinstall https://yum.theforeman.org/releases/2.0/el7/x86_64/foreman-release.rpm`
Repo for Katello:
`yum -y localinstall https://fedorapeople.org/groups/katello/releases/yum/3.15/katello/el7/x86_64/katello-repos-latest.rpm`
Repo For puppet:
`yum -y localinstall https://yum.puppet.com/puppet6-release-el-7.noarch.rpm`

Repo For EPEL Release ( Repo)
`yum -y localinstall https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm`

![installnewrepo.png](../../_resources/installnewrepo.png)

Install Foreman packages
`yum install foreman-release-scl`

![installforemanpackages.png](/tmp/.mount_Joplin5HLKzs/resources/app.asar/:/850e25817c964e3dbe76b709b97d2c)

Next install the katello dependencies. Katello is for
![pulplvmcreate.png](../../_resources/pulplvmcreate.png)remote configuration management

`yum -y install katello tfm-rubygem-hammer_cli_* foreman-proxy-content`

![katellodepend.png](../../_resources/katellodepend.png)

Then I added the hostname and IP address to the /etc/hosts file

`echo "192.168.122.59 foreman.halibel.local" >> /etc/hosts`

![addingiptohost.png](../../_resources/addingiptohost.png)

Also, be sure to document the VMS and their services onto a spreadsheet for later use.

* * *

Now to complete the installation of katello-foreman, run the following command below:

`foreman-installer --scenario katello --foreman-initial-admin-username admin --foreman-initial-admin-password 'your password'`

![completeinstall\].png](../../_resources/completeinstall].png)

* * *

**Initial Configuration of Foreman**
Create your organization in Foreman. This is very important.
`hammer organization create --name halibel.local`

![orglist.png](../../_resources/orglist.png)

Now Create the location of the vm. We are going to name it halibelATX.
`hammer location create --name halibelATX`

![locationcreate.png](../../_resources/locationcreate.png)

Now Create a sync the location with the organization

`hammer location add-organization --name HalibelATX --organization halibel.local`

![createdsync.png](../../_resources/createdsync.png)

* * *

Now , I we are going to create a LVM (Logical volume Manager) for our pulp drive. While this can also be done before the installation of foreman. I went with a LVM because it is recommend in the event I need to add more drives to /var/pulp or reduce its size at anytime without damaging any databases.

The following commands below were used to create the initial partition `fdisk /dev/vdb`
Create a new partition and then use the entire disk. Then change its type to lvm `8e`. Now `/dev/vdb1` has been created!

Then make the physical volume. `pvcreate /dev/vdb1`

![createnpv.png](../../_resources/createnpv.png)

`vgcreate pulp /dev/vdb1`

`lvcreate -L 99G pulp /dev/vdb1`

`lvrename pulp lvol0 pulp`

![pulplvmcreate.png](../../_resources/pulplvmcreate.png)

![mountpulp.png](../../_resources/mountpulp.png)

![pulpfstab.png](../../_resources/pulpfstab.png)

![importgpg.png](../../_resources/importgpg.png)

![addgpgkeyforeman.png](../../_resources/addgpgkeyforeman.png)

![addingrepoforeman.png](../../_resources/addingrepoforeman.png)

![addgpgkeyforeman.png](../../_resources/addgpgkeyforeman-1.png)

![OSExtrarepoadd.png](../../_resources/OSExtrarepoadd.png)

![osrepofix.png](../../_resources/osrepofix.png)

![addlastrepo.png](../../_resources/addlastrepo.png)

![Syncingrepo.png](../../_resources/Syncingrepo.png)

![addingepelgpg.png](../../_resources/addingepelgpg.png)

![addingepelkey.png](../../_resources/addingepelkey.png)

![addepelproduct.png](../../_resources/addepelproduct.png)

![addingepelrepo.png](../../_resources/addingepelrepo.png)

![syncepel.png](../../_resources/syncepel.png)

![creatingcontentview.png](../../_resources/creatingcontentview.png)

![symlinkerror.png](../../_resources/symlinkerror.png)

![addrepotocontentview.png](../../_resources/addrepotocontentview.png)

![activationkeycreate.png](../../_resources/activationkeycreate.png)

![subscriptionkeyadd.png](../../_resources/subscriptionkeyadd.png)

* * *

## PXE BOOT

![addcentosrompng.png](../../_resources/addcentosrompng.png)

![mountcdrom.png](../../_resources/mountcdrom.png)

![syncfromdisk.png](../../_resources/syncfromdisk.png)

![restorecontents.png](../../_resources/restorecontents.png)

![installationmediummade.png](../../_resources/installationmediummade.png)

![partitiontable.png](../../_resources/partitiontable.png)

![oshammer.png](../../_resources/oshammer.png)

![dumpkickstarttemplate.png](../../_resources/dumpkickstarttemplate.png)

![createnewprovision.png](../../_resources/createnewprovision.png)

![createnewenvironment.png](../../_resources/createnewenvironment.png)

![addhostgroup.png](../../_resources/addhostgroup.png)

![newhostgroupparam.png](../../_resources/newhostgroupparam.png)

![pxebootvm.png](../../_resources/pxebootvm.png)

![choosingnewvolume.png](../../_resources/choosingnewvolume.png)

![sshintonewvm.png](../../_resources/sshintonewvm.png)

## Registering Clients

![downloadsubmanager.png](../../_resources/downloadsubmanager.png)

![entitlementservererror.png](../../_resources/entitlementservererror.png)

![katellocorrectentitlementserver.png](../../_resources/katellocorrectentitlementserver.png)

![foremanacticationkeylist.png](../../_resources/foremanacticationkeylist.png)

![copycacertificates.png](../../_resources/copycacertificates.png)

![downloadcacert-successful.png](../../_resources/downloadcacert-successful.png)

![downloadcacert-successful2.png](../../_resources/downloadcacert-successful2.png)

![activationkeylist.png](../../_resources/activationkeylist.png)

![port404notopen.png](../../_resources/port404notopen.png)

![underscoreneeded-successfulregister!.png](../../_resources/underscoreneeded-successfulregister!.png)

![finishreginstructions.png](../../_resources/finishreginstructions.png)

![install-epelrel.png](../../_resources/install-epelrel.png)

![installkatellohosttools.png](../../_resources/installkatellohosttools.png)

![acceptgpgkey.png](../../_resources/acceptgpgkey.png)

![freeipaclient.png](../../_resources/freeipaclient.png)

* * *

# FreeIPA

![addingiptohosts.png](../../_resources/addingiptohosts.png)

![packagesinstall.png](../../_resources/packagesinstall.png)

![yesinstall.png](../../_resources/yesinstall.png)

![installing.png](../../_resources/installing.png)

![addingservicestofirewall.png](../../_resources/addingservicestofirewall.png)

![setupdns.png](../../_resources/setupdns.png)

![createdirector.png](../../_resources/createdirector.png)

![2020-12-16_15-42.png](../../_resources/2020-12-16_15-42.png)

![SETUPIPA.png](../../_resources/SETUPIPA.png)

![setupcomplete.png](../../_resources/setupcomplete.png)

![uninstallaftererror.png](../../_resources/uninstallaftererror.png)

![addingdnsforwarding.png](../../_resources/addingdnsforwarding.png)

![configuring.png](../../_resources/configuring.png)

![verifyadmin.png](../../_resources/verifyadmin.png)

![enableauthconfig.png](../../_resources/enableauthconfig.png)

![enablehomedir.png](../../_resources/enablehomedir.png)

![addadmintowheelgroup.png](../../_resources/addadmintowheelgroup.png)

![enablehomedirssuccessful.png](../../_resources/enablehomedirssuccessful.png)

![createuserlainey.png](../../_resources/createuserlainey-1.png)

![createuserlainey.png](../../_resources/createuserlainey.png)

![finishuserlainey.png](../../_resources/finishuserlainey.png)

![createseconduser.png](../../_resources/createseconduser.png)

* * *

![yum.png](../../_resources/yum.png)

![editdhcpconf.png](../../_resources/editdhcpconf.png)

![showdhcpconf.png](../../_resources/showdhcpconf.png)

![restartdhcpd.png](../../_resources/restartdhcpd.png)

![enabledhcpd.png](../../_resources/enabledhcpd.png)

![subnetcreate.png](../../_resources/subnetcreate.png)

![subnetcreate.png](../../_resources/subnetcreate-1.png)

![reloadfirewall.png](../../_resources/reloadfirewall.png)

![enablevsftpd.png](../../_resources/enablevsftpd.png)

![installvsftpd.png](../../_resources/installvsftpd.png)