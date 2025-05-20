# Custom Prometheus Exporters

This folder contains **custom Prometheus exporters** built to collect and expose metrics related to RDMA, InfiniBand, and performance testing. These exporters are designed to run as lightweight HTTP servers that Prometheus can scrape at regular intervals.

## 📦 Overview

These exporters are useful for environments where standard monitoring tools do not provide deep insight into low-level networking performance, especially with RDMA-capable systems or InfiniBand fabrics. They convert raw command-line tool outputs or system files into structured Prometheus metrics.

### Exporters Included

#### 🔹 `perftest_exporter.py`
- Runs `perftest` tools like `ib_write_bw` or `ib_read_bw`
- Extracts metrics such as bandwidth, latency, and message rate
- Useful for ongoing performance benchmarking

#### 🔹 `rdma_metrics_exporter.py`
- Scrapes RDMA device state from `/sys/class/infiniband`
- Reports per-port link state (`state`) and physical state (`phys_state`)
- Helps verify RDMA interface health in real time

#### 🔹 `ib_metrics_exporter.py`
- Parses detailed information from tools like `ibv_devinfo` or `ibstat`
- Can be extended to monitor MTU, link layer, and device attributes
- Good for integration with cluster-level InfiniBand diagnostics

## 🚀 Getting Started

1. Install dependencies:
   ```bash
   pip install prometheus_client
