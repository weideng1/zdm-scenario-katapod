<!-- TOP -->
<div class="top">
  <img class="scenario-academy-logo" src="https://datastax-academy.github.io/katapod-shared-assets/images/ds-academy-2023.svg" />
  <div class="scenario-title-section">
    <span class="scenario-title">Zero Downtime Migration Lab</span>
  </div>
</div>

<!-- NAVIGATION -->
<div id="navigation-top" class="navigation-top">
 <a title="Back" href='command:katapod.loadPage?[{"step":"step3"}]' 
   class="btn btn-dark navigation-top-left">⬅️ Back
 </a>
<span class="step-count">Step 4</span>
 <a title="Next" href='command:katapod.loadPage?[{"step":"step5"}]' 
    class="btn btn-dark navigation-top-right">Next ➡️
  </a>
</div>

<!-- CONTENT -->

<div class="step-title">Phase 1b: Start the proxy</div>

![Phase 1b](images/p1b.png)

#### _🎯 Goal: configuring and starting the Ansible playbook that automates the creation and deployment of the ZDM Proxy on the target machine(s)._

First start a `bash` shell on the `zdm-ansible-container`: this
will be needed a few times in the rest of this lab
(and will be in the "zdm-ansible-console" terminal).
_The next command will result in the prompt changing to_
_something like `ubuntu@4fb20a9b:~$`:_
_this terminal will stay in the container until the end._

```bash
### {"terminalId": "container", "backgroundColor": "#C5DDD2"}
docker exec -it zdm-ansible-container bash
```

It is time to configure the settings for the proxy that is
about to be created. To do so, you are going to edit
the file `zdm_proxy_cluster_config.yml` _on the container_,
adding connection parameters for both Origin and Target.

First check the IP address of the Cassandra node, with:

```bash
### host
. /workspace/zdm-scenario-katapod/scenario_scripts/find_addresses.sh
```

Moreover you'll need the Target database ID:
your database ID is simply given by this command:

```bash
### host
grep ASTRA_DB_ID /workspace/zdm-scenario-katapod/.env
```

In file `zdm_proxy_cluster_config.yml`, you'll have to uncomment and edit the entries in the following table.
_(Note that, within the container, all the file editing will have to be done in the console. To save and quit_
_`nano` when you are done, hit `Ctrl-X`, then `Y`, then `Enter`.)_

|Variable                 | Value                                                                                                                                                          |
|-------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`origin_username`        | cassandra                                                                                                                                                      |
|`origin_password`        | cassandra                                                                                                                                                      |
|`origin_contact_points`  | _The IP of the **Cassandra seed** node (**Note**: this is the value of_ `CASSANDRA_SEED_IP` _as printed by `find_addresses.sh`, and not the ZDM host address)_ |
|`origin_port`            | 9042                                                                                                                                                           |
|`target_username`        | token                                                                                                                                                          |
|`target_password`        | _the **"token"** string in your Astra DB Token" (the one starting with `AstraCS:...`)_                                                                                                           |
|`target_astra_db_id`     | _Your **Database ID** from the Astra DB dashboard_                                                                                                             |
|`target_astra_token`     | _the **"token"** string in your Astra DB Token" (the one starting with `AstraCS:...`)_                                                                         |


```bash
### {"terminalId": "container", "backgroundColor": "#C5DDD2"}
cd /home/ubuntu/zdm-proxy-automation/
nano ansible/vars/zdm_proxy_cluster_config.yml
```

_Note: `nano` might occasionally fail to start. In that case, hitting Ctrl-C in the console and re-launching the command would help._

Once the changes are saved,
you can run the Ansible playbook that will provision and start the proxy containers in the proxy host: still in the Ansible container, launch the command:

```bash
### {"terminalId": "container", "backgroundColor": "#C5DDD2"}
cd /home/ubuntu/zdm-proxy-automation/ansible
ansible-playbook deploy_zdm_proxy.yml -i zdm_ansible_inventory
```

HINT: while waiting for zdm-proxy to be deployed for the first time, 
you can skip over to Step 7 (Phase 2) to execute up to the "call the 
initialization API" block. That is an operation that will take 5+ minutes, 
so you can save some total run time. Once you initalize the migration in 
Step 7, you can come back to this Step 4 and continue the rest of the blocks.

The above ansible-playbook block will provision, configure and start the ZDM Proxy, one container per instance
(in this exercise there'll be a single instance, `zdm-proxy-container`).
Once this is done, you can check the new container is listed in the output of

```bash
### {"terminalId": "host", "backgroundColor": "#C5DDD2"}
docker ps
```

<details class="katapod-details">
<summary>If ZDM proxy fails to start, and you really want a little extra guidance, feel free to refer to the sample configuration file. (click to expand)</summary>
/workspace/zdm-scenario-katapod/.cheat/sample_zdm_proxy_cluster_config.yml
</details>

<details class="katapod-details">
<summary>If ZDM proxy installation fails at downloading secure connect bundle, because Astra DevOps API gives 403 error, you can use the SCB file astra-cli already downloaded in earlier step instead. (click to expand)</summary>
1. Outside of the containers, run `docker cp <$HOME/.astra/scb/scb_xxx.zip> zdm-ansible-container:/home/ubuntu/`;
2. Enter zdm-ansible-container, in `zdm_proxy_cluster_config.yml`, comment out `target_astra_db_id` and `target_astra_token` and set `target_astra_secure_connect_bundle_path` to `/home/ubuntu/scb_xxx.zip`;
3. Rerun the deploy playbook.
</details>

By inspecting the logs of the containerized proxy instance, you can verify that it has indeed
succeeded in connecting to the clusters:

```bash
### {"terminalId": "host", "backgroundColor": "#C5DDD2"}
docker logs zdm-proxy-container 2>&1 | grep "Proxy connected"
```

Alternatively, the ZDM Proxy exposes a health-status HTTP endpoint:
you can query it with

```bash
### {"terminalId": "host", "backgroundColor": "#C5DDD2"}
. /workspace/zdm-scenario-katapod/scenario_scripts/find_addresses.sh
curl -s http://${ZDM_HOST_IP}:14001/health/readiness | jq
```

#### _🗒️ The ZDM Proxy is now up and running, ready to accept connections just as if it were a regular Cassandra cluster. But before re-routing the client application, let's think about observability!_

<!-- NAVIGATION -->
<div id="navigation-bottom" class="navigation-bottom">
 <a title="Back" href='command:katapod.loadPage?[{"step":"step3"}]'
   class="btn btn-dark navigation-bottom-left">⬅️ Back
 </a>
 <a title="Next" href='command:katapod.loadPage?[{"step":"step5"}]'
    class="btn btn-dark navigation-bottom-right">Next ➡️
  </a>
</div>
