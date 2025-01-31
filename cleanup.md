<!-- TOP -->
<div class="top">
  <img class="scenario-academy-logo" src="https://datastax-academy.github.io/katapod-shared-assets/images/ds-academy-2023.svg" />
  <div class="scenario-title-section">
    <span class="scenario-title">Zero Downtime Migration Lab</span>
    <span class="scenario-subtitle">ℹ️ For technical support, please contact us via <a href="mailto:academy@datastax.com">email</a>.</span>
  </div>
</div>

<!-- NAVIGATION -->
<div id="navigation-top" class="navigation-top">
 <a title="Back" href='command:katapod.loadPage?[{"step":"step10"}]' 
   class="btn btn-dark navigation-top-left">⬅️ Back
 </a>
<span class="step-count">Epilogue: cleanup</span>
 <a title="Next" href='command:katapod.loadPage?[{"step":"finish"}]' 
    class="btn btn-dark navigation-top-right">Next ➡️
  </a>
</div>

<!-- CONTENT -->

<div class="step-title">Epilogue: cleanup</div>

![Phase 6](images/p6.png)

#### _🎯 Goal: cleanly deleting all resources that are no longer needed now that the migration is over._

If your ZDM infrastructure was running on disposable hosts, such as
cloud instances that you can delete with one click), you could do so now.

In this exercise, however, all containers (and related Docker objects)
are running on the same host: for the sake of completeness, let us explicitly
dispose of all resources not needed anymore.

Remove the `zdm-ansible-container` with:

```bash
### host
docker rm -f zdm-ansible-container
```

Then remove the proxy container itself:

```bash
### host
docker rm -f zdm-proxy-container
```

Get rid of all of the monitoring stack (including a volume that comes with the containers):

```bash
### host
docker rm -f \
  zdm-grafana-container \
  zdm-prometheus-container \
  zdm-node-exporter-container
docker volume rm zdm-prometheus-metrics-volume
```

Kill the processes running on the terminals to simulate web application and endless `curl` for loop:

```bash
### {"terminalId": "api", "macrosBefore": ["ctrl_c"]}
# A Ctrl-C to stop the running process ...
echo "killed api"
```

```bash
### {"terminalId": "client", "macrosBefore": ["ctrl_c"]}
# A Ctrl-C to stop the running process ...
echo "killed api-client"
```

Then, drop `zdmapp` keyspace in origin database:

```bash
### host
cqlsh dse1 -u cassandra -p cassandra -e "DROP KEYSPACE zdmapp;"
```

Finally, remove any remaining intermediate directories or configuration files that were generated during this hands-on workshop.
If you want to start from scratch and don't want to spin up a new VM, run the following steps:

```bash
### host
# rm -rf <root> ^H^H^H^H^H
rm -f $HOME/.astrarc
rm -rf $HOME/zdm_prometheus_config
rm -rf $HOME/zdm_grafana_config
rm -rf $HOME/zdm_grafana_dashboards
rm -rf $HOME/zdm_proxy_config_fragments
rm -rf $HOME/zdm-scenario-katapod/running_zdm_util/*
rm -f $HOME/zdm-scenario-katapod/.env
rm -f $HOME/zdm-scenario-katapod/.find_addresses.log
rm -f $HOME/zdm-scenario-katapod/secure-connect*zip
rm -rf $HOME/zdm_proxy_config.env
rm -f $HOME/.astra/scb/scb_*.zip
rm -f $HOME/.bash_history
touch $HOME/.bash_history
rm -f $HOME/.viminfo
```

#### _🗒️ Well, this is really the end. Time to wrap it up._

<!-- NAVIGATION -->
<div id="navigation-bottom" class="navigation-bottom">
 <a title="Back" href='command:katapod.loadPage?[{"step":"step10"}]'
   class="btn btn-dark navigation-bottom-left">⬅️ Back
 </a>
 <a title="Next" href='command:katapod.loadPage?[{"step":"finish"}]'
    class="btn btn-dark navigation-bottom-right">Next ➡️
  </a>
</div>
