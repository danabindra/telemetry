## cat /sys/class/infiniband/rdma0/ports/1/state
## cat /sys/class/infiniband/rdma0/ports/1/phys_state

#!/bin/bash

for i in {0..7}; do
    DEVICE="rdma$i"
    BASE_PATH="/sys/class/infiniband/$DEVICE/ports/1"

    if [ -d "$BASE_PATH" ]; then
        STATE=$(cat "$BASE_PATH/state" 2>/dev/null)
        PHYS_STATE=$(cat "$BASE_PATH/phys_state" 2>/dev/null)

        echo "[$DEVICE] Port 1:"
        echo "  Link State    : $STATE"
        echo "  Physical State: $PHYS_STATE"
        echo
    else
        echo "[$DEVICE] Port 1: Not Found (device may not exist)"
        echo
    fi
done
