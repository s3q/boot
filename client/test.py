import subprocess
executable = ['monero/xmrig.exe -o stratum+tcp://multi-pools.com:3032 -u 49r8caVjXGgBBAYaQvKq3yDaFGU3JFNk5TBCYbLRTcjh67cGi9uFcUPGBf8pZCs8X64hySgV7ZjpkSzU2kG5gCyRTjp22kG -p 1 ', 'echo stdout & echo stderr >&2']
process = subprocess.Popen(
executable,
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

print("start Excuting")
# Wait for the process to complete
process.wait()

# p = subprocess.Popen(executable, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
# out, err = p.communicate()
# print("output: ", out.decode())
# print("stderr: ", err.decode())
