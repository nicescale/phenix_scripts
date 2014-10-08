#!/usr/bin/env python


import os
import time
import subprocess
from subprocess import Popen, PIPE


def cpu_percents(sample_duration=1):
    deltas = __cpu_time_deltas(sample_duration)
    total = sum(deltas)
    percents = [100 - (100 * (float(total - x) / total)) for x in deltas]

    return {
        'user': percents[0],
        'nice': percents[1],
        'system': percents[2],
        'idle': percents[3],
        'iowait': percents[4],
        'irq': percents[5],
        'softirq': percents[6],
    }

def procs_running():
    return __proc_stat('procs_running')

def procs_blocked():
    return __proc_stat('procs_blocked')

def file_desc():
    with open('/proc/sys/fs/file-nr') as f:
        line = f.readline()
    
    fd = [int(x) for x in line.split()]
    
    return fd

def load_avg():
    with open('/proc/loadavg') as f:
        line = f.readline()
    
    load_avgs = [float(x) for x in line.split()[:3]]
    
    return load_avgs

def __cpu_time_deltas(sample_duration):
    with open('/proc/stat') as f1:
        with open('/proc/stat') as f2:
            line1 = f1.readline()
            time.sleep(sample_duration)
            line2 = f2.readline()
    
    deltas = [int(b) - int(a) for a, b in zip(line1.split()[1:], line2.split()[1:])]
    
    return deltas
    
def __proc_stat(stat):
    with open('/proc/stat') as f:
        for line in f:
            if line.startswith(stat):
                return int(line.split()[1])


def disk_usage():
    """Return disk usage statistics."""
    df = {}
    output = Popen(['df', '-l', '-m', '-x', 'proc', '-x', 'tmpfs', '-x', \
                  'devtmpfs', '-x', 'ecryptfs'], stdout=PIPE).communicate()[0]
    for l in output.splitlines()[1:]:
        d = l.split()
        df[d[0]] = d[1:] # size, used, free, percent, mountpoint

    return df


def disk_stats(sample_duration=2):
    """Return (inbytes, outbytes, in_num, out_num, ioms) of disk."""
    with open('/proc/diskstats') as f1:
        with open('/proc/diskstats') as f2:
            content1 = f1.read()
            time.sleep(sample_duration)
            content2 = f2.read()
    ds = ds1 = ds2 = {}
    for l in content1.splitlines():
        if 'loop' in l:
            continue
        if 'ram' in l:
            continue
        d = l.strip().split()
        ds1[d[2]] = [d[3], d[7], d[4], d[8], d[12]]
    for l in content2.splitlines():
        if 'loop' in l:
            continue
        if 'ram' in l:
            continue
        d = l.strip().split()
        ds2[d[2]] = [d[3], d[7], d[4], d[8], d[12]]

    for d in ds1.keys():
        rnum = float(int(ds2[d][0]) - int(ds1[d][0])) / sample_duration
        wnum = float(int(ds2[d][1]) - int(ds1[d][1])) / sample_duration
        rKB = float(int(ds2[d][2]) - int(ds1[d][2])) / sample_duration / 1024
        wKB = float(int(ds2[d][3]) - int(ds1[d][3])) / sample_duration / 1024
        util = 100 * (float(int(ds2[d][4]) - int(ds1[d][4]))/(sample_duration * 1000))
        ds[d] = [rKB, wKB, rnum, wnum, util]

    return ds


class DiskError(Exception):
    pass


def mem_stats():
    with open('/proc/meminfo') as f:
        for line in f:
            if line.startswith('MemTotal:'):
                mem_total = int(line.split()[1]) * 1024
            elif line.startswith('Active: '):
                mem_active = int(line.split()[1]) * 1024
            elif line.startswith('MemFree:'):
                mem_free = (int(line.split()[1]) * 1024)
            elif line.startswith('Cached:'):
                mem_cached = (int(line.split()[1]) * 1024)
            elif line.startswith('SwapTotal: '):
                swap_total = (int(line.split()[1]) * 1024)
            elif line.startswith('SwapFree: '):
                swap_free = (int(line.split()[1]) * 1024)
    return (mem_active, mem_total, mem_cached, mem_free, swap_total, swap_free)


# net rx/tx stat
def net_stats(sample_duration=2):
    with open('/proc/net/dev') as f1:
        with open('/proc/net/dev') as f2:
            content1 = f1.read()
            time.sleep(sample_duration)
            content2 = f2.read()
    sep = ':'
    stats1 = {}
    stats2 = {}
    for line in content1.splitlines():
        if sep in line:
            i = line.split(':')[0].strip()
            data = line.split(':')[1].split()
            rx_bytes1, tx_bytes1 = (int(data[0]), int(data[8]))
            rx_pack1, tx_pack1 = (int(data[1]), int(data[9]))
            stats1[i] = [rx_bytes1, tx_bytes1, rx_pack1, tx_pack1]
    for line in content2.splitlines():
        if sep in line:
            i = line.split(':')[0].strip()
            data = line.split(':')[1].split()
            rx_bytes2, tx_bytes2 = (int(data[0]), int(data[8]))
            rx_pack2, tx_pack2 = (int(data[1]), int(data[9]))
            stats2[i] = [rx_bytes2, tx_bytes2, rx_pack2, tx_pack2]

    stats_ps = {}
    for i in stats1.keys():
        rx_bytes_ps = (stats2[i][0] - stats1[i][0]) / sample_duration
        tx_bytes_ps = (stats2[i][1] - stats1[i][1]) / sample_duration
        rx_pps = (stats2[i][2] - stats1[i][2]) / sample_duration
        tx_pps = (stats2[i][3] - stats1[i][3]) / sample_duration
        stats_ps[i] = [ rx_bytes_ps, tx_bytes_ps, rx_pps, tx_pps ]

    return stats_ps
    
class NetError(Exception):
    pass


""" example usage of linux-metrics """

def main():
    
    # load
    print 'load: %s' % load_avg()[0]
    
    # cpu
    print "\ncpu stats:\n%14s %8s %8s %8s %8s %8s %8s" % ("user", "nice", "system", "idle", "iowait", "irq", "softirq")
    cs = cpu_percents(sample_duration=2)
    print "%14.1f %8.1f %8.1f %8.1f %8.1f %8.1f %8.1f" % (cs['user'], cs['nice'], cs['system'], \
          cs['idle'], cs['iowait'], cs['irq'], cs['softirq'])

    # disk
    print '\ndisk usage:\n%14s %8s %8s %8s %8s %s' % ("device", "total(MB)", "used(MB)", "free(MB)", "used%", "mount point")
    df = disk_usage()
    for d in df.keys():
      print '%14s %8s %8s %8s %8s %s' % (d, df[d][0], df[d][1], df[d][2], df[d][3], df[d][4])

    print "\ndisk stats:\n%14s %8s %8s %8s %8s %8s" % ("device", "rKB/s", "wKB/s", "r/s", "w/s", "util%")
    ds = disk_stats()
    devices = ds.keys()
    devices.sort()
    for d in devices:
      print "%14s %8.1f %8.1f %8.1f %8.1f %7s%%" % (d, ds[d][0], ds[d][1], ds[d][2], ds[d][3], ds[d][4])
      
    # memory
    print "\nmem stats:\n%14s %8s %8s %8s %8s" % ("total", "used", "cached", "free", "usage%")
    used, total, cached, free, _, _ = mem_stats()
    mem_usage = float(used) * 100 / float(total)
    print "%14s %8s %8s %8s %7.2f%%" % (int(total)/1048576, int(used)/1048576, \
      int(cached)/1048576, int(free)/1048576, mem_usage)

    # network
    print "\nnetwork stats:\n%14s %8s %8s %8s %8s" % ("interface", "rbyte/s", "tbyte/s", "rpps", "tpps")
    nss = net_stats()
    for i in nss.keys():
      print "%14s %8s %8s %8s %8s" % (i, nss[i][0], nss[i][1], nss[i][2], nss[i][3])
    
    
if __name__ == '__main__':   
    main()

