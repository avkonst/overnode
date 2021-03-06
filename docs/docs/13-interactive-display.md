---
id: interactive-display
title: Weave scope interactive dashboard
sidebar_label: Weave scope dashboard
---

## Adding the pre-configured stack

Overnode provides the pre-configured stack for [Weave scope](https://www.weave.works/oss/scope/). This is an amazing interactive browser which brings ultimate visibility to your cluster.

To add the stack to a project, run the following:

```bash
> sudo overnode init https://github.com/overnode-org/overnode@examples/infrastructure/weavescope
```

The stack will open `4430` port on each host in a cluster. The server uses self-signed certificate. And the Basic HTTP username/password is configured to `admin`/`admin`. These are the main configurations which you may want to change. All other settings should work automatically well.
