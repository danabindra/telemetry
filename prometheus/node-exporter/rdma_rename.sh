#!/bin/bash
_400g_DEVICE="0x1760" #note: update to regex when we have >1 device id
_400g_DEVICE_NAME_TEMPLATE="rdma%d"
_OTHER_DEVICE_NAME_TEMPLATE="xeth%d"
UDEV_RENAME_BIN="/usr/lib/udev/rdma_rename"

if [ ! -f ${UDEV_RENAME_BIN} ]; then
    echo "ERROR: rdma_rename binary from rdma-core package must be installed" 1>&2
    exit 1
fi

DEVICES=$(ls /sys/class/infiniband)

#determine the type of device
_devices=$(grep ${_400g_DEVICE} /sys/class/infiniband/*/device/device | cut -f 5 -d/)
_other=$(grep -v ${_400g_DEVICE} /sys/class/infiniband/*/device/device | cut -f 5 -d/)

DEVICES_BY_PCI=''
for d in $DEVICES; do
    if [ "${DEVICES_BY_PCI}x" != 'x' ]; then DEVICES_BY_PCI+=$'\n'; fi
    DEVICES_BY_PCI+=$(realpath /sys/class/infiniband/${d}/device)
    DEVICES_BY_PCI+=":$d"
done
DEVICES_BY_PCI=$(echo "$DEVICES_BY_PCI" | sort | grep .)

_400g_DEVICES=''
for d in $_devices; do
    _400g_DEVICES+=$(echo "$DEVICES_BY_PCI" | grep ":$d$")
    _400g_DEVICES+=$'\n'
done
_400g_DEVICES=$(echo "$_400g_DEVICES" | sort | grep .)

_OTHER_DEVICES=''
for d in $_other; do
    _OTHER_DEVICES+=$(echo "$DEVICES_BY_PCI" | grep ":$d$")
    _OTHER_DEVICES+=$'\n'
done
_OTHER_DEVICES=$(echo "$_OTHER_DEVICES" | sort | grep .)

for DEV_NAME in $DEVICES; do
    if [ -z "$DEV_NAME" ]; then
        echo "ERROR: Unable to parse device name" 1>&2
        exit 1
    fi

    _device_line=$(echo "${_400g_DEVICES}" | grep -n :${DEV_NAME}\$ | cut -f 1 -d:)
    _other_line=$(echo "${_OTHER_DEVICES}" | grep -n :${DEV_NAME}\$ | cut -f 1 -d:)

    if [ ! -z "${_device_line}" ]; then
        _id=$(expr ${_device_line} - 1)
        _hyrdated_template=$(printf "${_400g_DEVICE_NAME_TEMPLATE}" ${_id})
    elif [ ! -z "${_other_line}" ]; then
        _id=$(expr ${_other_line} - 1)
        _hyrdated_template=$(printf "${_OTHER_DEVICE_NAME_TEMPLATE}" ${_id})
    else
        echo "ERROR: Could not locate ${DEV_NAME} in /sys/class/infiniband device tree" 1>&2
        exit 1
    fi

    if [ "${DEV_NAME}" != "${_hyrdated_template}" ]; then
        ${UDEV_RENAME_BIN} ${DEV_NAME} NAME_FIXED ${_hyrdated_template}
    fi
done
