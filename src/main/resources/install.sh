#!/bin/bash

#
# Generated by Webintrinsics Clusterlite:
# __COMMAND__
#
# Parameters: __PARSED_ARGUMENTS__
# Environment: __ENVIRONMENT__
# Prerequisites:
# - Docker engine
# - Internet connection
#

set -e

weave_image="clusterlite/weave:1.9.7"
proxy_image="clusterlite/proxy:3.6"
etcd_image="clusterlite/etcd:3.1.0"

install() {
    echo "__LOG__ downloading clusterlite images"
    sudo docker pull ${weave_image}
    sudo docker pull ${proxy_image}
    sudo docker pull ${etcd_image}

    echo "__LOG__ extracting weave script"
    docker_location="$(which docker)"
    weave_destination="${docker_location/docker/weave}"
    docker run --rm -i ${weave_image} > ${weave_destination}
    chmod u+x ${weave_destination}

    echo "__LOG__ downloading weave images"
    ${weave_destination} setup

    echo "__LOG__ installing data directory"
    mkdir /var/lib/clusterlite || echo ""
    echo __VOLUME__ > /var/lib/clusterlite/volume.txt
    mkdir __VOLUME__ || echo ""
    mkdir __VOLUME__/clusterlite || echo ""
    echo __CONFIG__ > __VOLUME__/clusterlite.json

    echo "__LOG__ installing weave network"
    export CHECKPOINT_DISABLE=1 # disabling weave check for new versions
    # launching weave node for uniform dynamic cluster with encryption is enabled
    # see https://www.weave.works/docs/net/latest/operational-guide/uniform-dynamic-cluster/
    # automated range allocation does not require seeds to reach a consensus
    # because the range is split in advance by seeds enumeration
    # see https://github.com/weaveworks/weave/blob/master/site/ipam.md#via-seed
    weave launch-router --password __TOKEN__ \
        --dns-domain="clusterlite.local." \
        --ipalloc-range 10.47.240.0/20 --ipalloc-default-subnet 10.32.0.0/12 \
        __WEAVE_SEED_NAME__ --ipalloc-init seed=__WEAVE_ALL_SEEDS__ __SEEDS__
    # integrate with docker using weave proxy, it is more reliable than weave plugin
    weave launch-proxy --rewrite-inspect

    echo "__LOG__ starting docker proxy"
    weave_socket=$(weave config)
    docker ${weave_socket} run --name clusterlite-proxy -dti --init \
        --hostname clusterlite-proxy.clusterlite.local \
        $(weave dns-args) \
        --env CONTAINER_NAME=clusterlite-proxy \
        --env SERVICE_NAME=clusterlite-proxy.clusterlite.local \
        --volume ${weave_socket#-H=unix://}:/var/run/docker.sock:ro \
        --restart always \
        ${proxy_image} /run-proxy.sh __NODE_ID__
__ETCD_LAUNCH_PART__

    echo "__LOG__ done"
}
install
