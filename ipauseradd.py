#!/bin/python3
  
import os,sys,subprocess

first = sys.argv[1]
last = sys.argv[2]
if isinstance(first,str):
    print(f'Adding user {first} {last}!')
    os.system(f"ipa user-add {first} --first={first} --last={last} --email={first}.{last}@halibelv2.local --password")
    print(f"{first}'s user account has been created!")
elif isinstance(first,int):
    print("Unacceptable input! Please tryagain and enter a string value")
else:
     print("Unacceptable input! Please tryagain and enter a string value. Run the script again")
print(f"{first}'s user account has been created!")

