#!/bin/bash

#
# License: https://github.com/webintrinsics/clusterlite/blob/master/LICENSE
#

#vendor="clusterlite"

#build_image cassandra
#build_image telegraf
#build_image influxdb
#build_image chronograf
#build_image elasticsearch
build_image zookeeper
#build_image kafka
#build_image spark
#build_image zeppelin

docker_login

#push_image cassandra
#push_image telegraf
#push_image influxdb
#push_image chronograf
#push_image elasticsearch
push_image zookeeper
#push_image kafka
#push_image spark
#push_image zeppelin
