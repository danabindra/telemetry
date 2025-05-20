# 🛰️ Drift Detector in Grafana Dshboard

This project uses **Ansible** automation to gather hardware and software metrics from a GPU node cluster and export them to **Prometheus**, which visualizes them via **Grafana** dashboards.

---

## 📊 What It Does

✅ Collects system-level metrics:
- GPU BIOS versions
- ROCm driver versions
- Node Exporter state
- `rdma link show` status
- Checks for specific `rocm-smi` versions

✅ Automation pipeline:
- Collect data with Ansible
- Write metrics to **Prometheus textfile collectors**
- Scrape with Prometheus
- Visualize via Grafana
- Triggered via cron job or Jenkins pipeline

---

## 🧱 Architecture

```plaintext
[Ansible] → [Metric Collector Script] → [Prometheus textfile dir]
                                      ↳ metrics.node -> /var/lib/node_exporter/textfile_collector/

[Prometheus] ← scrapes metrics ← [Node Exporter]
                               ↓
                         [Grafana Dashboards]
