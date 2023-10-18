#Author:Lainey Tubbs

#Usage: to backup the /home,/etc/,/boot

import os 
import tarfile
import datetime 

directories = ["/etc", "/home" , "/boot"] #lists directories that need to be backed up
#newArchName= (f'{directory}.backup.{datetime.date.today()}.tar.gz')

def backupdir(directories): #function to backup the cdirectory
	os.chdir('/') #change to root directory
	for directory in directories: #takes list of directories being backed up
		with tarfile.open(f"{directory}.{datetime.date.today()}.backup.tar.gz" , "w:gz" ) as tar: #assigns the directory being backed up .tar.gz to be assigned to variable tar
			print(f"Creating new tarfile {directory}.{datetime.date.today()}.backup.tar.gz !") 
			tar.add(directory) #compresses the director in gzip
			print(f"{directory}.{datetime.date.today()}.backup.tar.gz has been created! Moving to /virtual-drives !")
			os.system(f'mv {directory}.{datetime.date.today()}.backup.tar.gz /virtual-drives/')
			print(f"{directory}.{datetime.date.today()}.backup.tar.gz has been moved to /virtual-drives/!")
backupdir(directories)
print("Backup complete!")


