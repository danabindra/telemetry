# rdma_exporter.py
from prometheus_client import start_http_server, Gauge
import subprocess
import time
import re

# Define Prometheus metrics
bandwidth_gbps = Gauge('rdma_bandwidth_gbps', 'RDMA Bandwidth in Gbps')
latency_usec = Gauge('rdma_latency_usec', 'RDMA Latency in microseconds')  # Optional

def run_perftest():
    try:
        result = subprocess.run(
            ["ib_write_bw", "-F", "-q", "1", "-n", "1000", "--report_gbits", "localhost"],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            timeout=10,
            text=True
        )
        output = result.stdout
        # Example match: 33554432  0.00   0.00   22.33 ...
        match = re.search(r"\d+\s+\d+\.\d+\s+\d+\.\d+\s+(\d+\.\d+)", output)
        if match:
            bw = float(match.group(1))
            bandwidth_gbps.set(bw)
        else:
            bandwidth_gbps.set(0.0)
    except Exception as e:
        print(f"Error running perftest: {e}")
        bandwidth_gbps.set(0.0)

if __name__ == '__main__':
    start_http_server(8000)  # Exporter on port 8000
    while True:
        run_perftest()
        time.sleep(60)  # run once per minute
