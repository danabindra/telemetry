from prometheus_client import Gauge, start_http_server
import subprocess
import time
import re

bw_avg = Gauge('perftest_bw_avg_mb', 'Average bandwidth in MB/sec')
bw_peak = Gauge('perftest_bw_peak_mb', 'Peak bandwidth in MB/sec')
msg_rate = Gauge('perftest_msg_rate_mpps', 'Message rate in Mpps')

def run_perftest():
    try:
        output = subprocess.check_output(["ib_write_bw", "--dual"], text=True)
        # Example line: "65536  5000  12100.50  11950.35  0.190"
        for line in output.splitlines():
            if re.match(r'^\d+\s+\d+\s+', line):
                parts = line.split()
                bw_peak.set(float(parts[2]))
                bw_avg.set(float(parts[3]))
                msg_rate.set(float(parts[4]))
    except Exception as e:
        print("Error running perftest:", e)

if __name__ == "__main__":
    start_http_server(9100)
    while True:
        run_perftest()
        time.sleep(60)  # Run once per minute
