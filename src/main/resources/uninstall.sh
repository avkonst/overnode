#!/bin/bash

#
# Generated by Webintrinsics Clusterlite:
# __COMMAND__
#
# Parameters: __PARSED_ARGUMENTS__
# Environment: __ENVIRONMENT__
# Prerequisites:
# - clusterlite install
#

set -e

uninstall() {
    echo "__LOG__ stopping proxy server"
    docker exec -it clusterlite-proxy /run-proxy-remove.sh __NODE_ID__ || \
        echo "__LOG__ warning: failure to detach the node"
    docker stop clusterlite-proxy || \
        echo "__LOG__ warning: failure to stop clusterlite-proxy container"
    docker rm clusterlite-proxy || \
        echo "__LOG__ warning: failure to remove clusterlite-proxy container"
__ETCD_STOP_PART__
    echo "__LOG__ uninstalling weave network"
    # see https://www.weave.works/docs/net/latest/ipam/stop-remove-peers-ipam/
    weave reset || echo "__LOG__ warning: failure to reset weave network"

    echo "__LOG__ uninstalling data directory"
    rm -Rf __VOLUME__ || echo "__LOG__ warning: some data has not been removed"
    rm -Rf /var/lib/clusterlite || echo "__LOG__ warning: some data has not been removed"

    echo "__LOG__ done"
}
uninstall
