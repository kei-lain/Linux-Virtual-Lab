#Netcat replacement!

#Usage: This 

#Author: Lainey Tubbs


#importing libraries 

import sys
import socket
import getopt
import threading
import subprocess


#Define some global variables

listen = False
command = False
upload = False
execute = " "
target  = " "
upload_destination = " "
port = 0 


def usage():
    print "Lain's Net Tool"
    print()
    print("Usage: lainnet.py -t target_host -p port")
    print()
    print (" --l --listen                          -listen on [host]:[port] for incoming connections")
    print()
    print ( "-e ---execute=file_to_run          -Execute the given file upon receiving a connection")
    print("-c  --command                         -Initialize a command shell")
    print()
    print()
    print()
    print("Examples: ")
    print("lainnet.py -t 192.168.0.2 -p 5555 -l -c")
    print("lainnet.py -t 192.168.0.2 -p 5555 -l -u=c:\\target.exe")
    print("lainnet.py -t 192.168.0.2 -p 5555 -l -e=\"cat /etc/passwd\"")
    print("echo 'ABDCEFGHI' | ./lainnet.py -t 192.168.11.12 -p 135"
    sys.exit(0)

def main():
    global listen
    global port
    global execute
    global command 
    global upload_destination
    global target

    if not len(sys.argv[1:]):
        usage()

    #read the commandline options
    try:
        opts, args = getopt.getopt(sys.argv[1: ],"hle:t:p:cu:",
        ["help","listen","execute","target","port","command","upload"])
    except getopt.GetoptError as err:
        print(str(err))
        usage()

    for o, a in opts:
        if o in ("-h", " - -help"):
            usage()
        elif o in ("-l" , "--listen"):
            listen = True
        elif o in ("-c","--commandshell"):
            command = True
        elif o in ("-u","--upload"):
            upload_destination = a
        elif o in ("-t", "--target"):
            target = a
        elif o in ("-p","--port"):
            port = int(a)
        else:
            assert False , "Unhandled Option"
    
    if not listen and len(target) and port > 0:

        #read in the bugger from the commandline
        #This will block, so send CTRL-D if not sending input
        #to stdin
        bufffer = sys.stdin.read()

        #send data off
        client_sender(buffer)

    if listen:
        server_loop()

main()

def client_sender(buffer):
    client = socket.socket(socket.AF_INET,socket.SOCK_STREAM)

    try:

        #connect to oour target host
        client.connect((target,port))

        if len(buffer):
            client.send(buffer)
        while True:
            #now wait for data back
            recv_len = 1
            response = " "

            while recv_len:
                data        = client.recv(4096)
                recv_len    = len(data)
                response    += data

                if recv_len < 4096:
                    break
            print(response)

            buffer = raw = inputbuffer += "\n"

            client.send(buffer)

    except:
        print "[*] Exception! Exiting."
        client.close()


def server_loop():
    global target
    if not len(target):
        target = "0.0.0.0"

    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind((target,port))
    server.listen(5)

    while True:
        client_socket, addr = server.accept()

        #spin off a thread to handle our new client
        client_thread= threading.Thread(target=client_handler, args=(client_socket,)) 
        client_thread.start()


def run_command(command):

    command = command.rstrip()
    try:
        output = subprocess.check_output(command,stderr=subprocess.STDOUTS, shell=True)
        except:
            output = "Failed to execute command. \r\n"

        return output