import psutil
import cpuinfo
import os
import speedtest
import GPUtil
import wmi
import platform

def get_size(bytes, suffix="B"):
    """
    Scale bytes to its proper format
    e.g:
        1253656 => '1.20MB'
        1253656678 => '1.17GB'
    """
    factor = 1024
    for unit in ["", "K", "M", "G", "T", "P"]:
        if bytes < factor:
            return f"{bytes:.2f}{unit}{suffix}"
        bytes /= factor

uname = platform.uname()
print(f"System: {uname.system}")
print(f"Node Name: {uname.node}")
print(f"Release: {uname.release}")
print(f"Version: {uname.version}")
print(f"Machine: {uname.machine}")
print(f"Processor: {uname.processor}")

# Functions to retrieve information and features
def get_cpu_info():

    info_map = {
        "brandRaw": cpuinfo.get_cpu_info()["brand_raw"],
        "cores": psutil.cpu_count(logical=False),
        "usedCores": psutil.cpu_percent(),
        "maxFrequency": psutil.cpu_freq().max,
        "minFrequency": psutil.cpu_freq().min,
        "currentFrequency": psutil.cpu_freq().current,
        "bits": cpuinfo.get_cpu_info()["bits"],
    }

    # Get temperature sensor readings
    # w = wmi.WMI(namespace="root\\OpenHardwareMonitor")
    # temperature_info = w.Sensor()
    
    # for sensor in temperature_info:
    #     if sensor.SensorType == u'Temperature' and sensor.Name == u'CPU Package':
    #         info_map["temperature"] = sensor.Value
    #         break

    return info_map
        
    

def get_gpu_info():
    gpus = GPUtil.getGPUs()
    info_map = {}
    i = 0
    for gpu in gpus:
        info_map[i] = {}
        info_map[i]["name"] = gpu.name
      
        info_map[i]["load"] = gpu.load

        info_map[i]["free"] = gpu.memoryFree

        info_map[i]["memoryTotal"] = gpu.memoryTotal
     
        info_map[i]["temperature"] = gpu.temperature
       
        i += 1
    return info_map

def get_ram_info():
    svmem = psutil.virtual_memory()
    swap = psutil.swap_memory()

    return {
        "available": get_size(svmem.available),
        "capacity": get_size(svmem.total),
        # "used": get_size(svmem.used),
        "percentage": svmem.percent,
        "swapPercentage": swap.percent
    }

def get_running_mountpoint():
    script_path = os.path.abspath(__file__)
    mountpoint = script_path.split(":\\")[0]
    return mountpoint.lower()


def get_hard_drive_info():
    disk_io = psutil.disk_io_counters()
    partitions = psutil.disk_partitions()


    info_map = {
        "read": get_size(disk_io.read_bytes),
        "write": get_size(disk_io.write_bytes)
    }

    mountpoint = get_running_mountpoint()

    for partition in partitions:

        if (mountpoint + ":\\" == partition.mountpoint.lower()):
            
            try:
                partition_usage = psutil.disk_usage(partition.mountpoint)
            except PermissionError:
                # this can be catched due to the disk that
                # isn't ready
                continue
            info_map["percentage"] = partition_usage.percent
    return info_map



def get_internet_speed():
    st = speedtest.Speedtest()
    st.get_best_server()

    return {
        "download":  st.download() / 1_000_000,
        "upload": st.upload() / 1_000_000
    }

# boot_time_timestamp = psutil.boot_time()
# bt = datetime.fromtimestamp(boot_time_timestamp)
# print(f"Boot Time: {bt.year}/{bt.month}/{bt.day} {bt.hour}:{bt.minute}:{bt.second}")

def get_system_info(): 
    return {
        "system": uname.system,
        "version": uname.version,
         "bootTime": psutil.boot_time(),
    }

def get_hardware_info():
    return {
        "cpu": get_cpu_info(),
        "gpu": get_cpu_info(),
        "ram": get_ram_info(),
        "disk": get_hard_drive_info(),
        "system": get_system_info(),

    }

def installed_tools():
    installed_tools_list = []
    monero_path = "monero"
    ddos_path = "ddos"
    if (os.access(monero_path, os.R_OK)):
        installed_tools_list.append("monero")
    if (os.access(ddos_path, os.R_OK)):
        installed_tools_list.append("ddos")

    return installed_tools_list