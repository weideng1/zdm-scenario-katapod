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
  <a title="Back" href='command:katapod.loadPage?[{"step":"step1"}]' 
    class="btn btn-dark navigation-top-left">⬅️ Back
  </a>
  <span class="step-count">Step 2 (Astra UI)</span>
  <a title="Next" href='command:katapod.loadPage?[{"step":"step3"}]' 
    class="btn btn-dark navigation-top-right">Next ➡️
  </a>
</div>

<!-- CONTENT -->

<div class="step-title">Preliminary step: set up Target</div>

![Phase 0b](images/p0b.png)

#### _🎯 Goal: creating the Target database (Astra DB instance) and verifying it is ready for the migration._

_The Target database you are going to create is an **Astra DB** instance.
This managed solution, built on Apache Cassandra™, frees you from
worrying about operations; moreover, it is a serverless architecture
that scales with your needs, avoiding unnecessary resource usage.
If you don't have an Astra account, [go create one](https://astra.datastax.com/): the **Free Tier**
can cover much, much more I/O and storage than what's needed for
this migration exercise._

**Note**: you are going to execute the following steps within the Astra Web interface.

- Create your [Astra account](https://astra.datastax.com/) if you haven't yet.
- Create a database called `zdmtarget` with a `zdmapp` keyspace ([detailed instructions](https://awesome-astra.github.io/docs/pages/astra/create-instance/)). _Use the AWS cloud provider. The DB will be ready to use in 2-3 minutes._
- Get a **"Database Administrator"** database token from the Astra UI and store it in a safe place ([detailed instructions](https://awesome-astra.github.io/docs/pages/astra/create-token/#c-procedure)). _You will need it a few times throughout the exercise._
- Locate and note down the "Database ID" for your Astra DB instance. This is seen on your Astra dashboard, next to your database name ([detailed instructions](https://awesome-astra.github.io/docs/pages/astra/faq/#where-should-i-find-a-database-identifier)).
- Find the "Download Secure Connect Bundle" dialog for your database in the Astra UI ([detailed instructions](https://awesome-astra.github.io/docs/pages/astra/download-scb/#c-procedure)), then copy the `curl` command and paste it in the "host-console" here to download it to this environment. _Take a note of the full path to the downloaded bundle zipfile, you'll need it for the example API to run_.
- In your database's [Web CQL Console](https://awesome-astra.github.io/docs/pages/astra/faq/#how-to-open-the-web-cql-console) on the Astra UI, paste the following script to create a schema mirroring the one on Origin:

```cql
### {"execute": false}
CREATE TABLE IF NOT EXISTS zdmapp.user_status (
  user    TEXT,
  when    TIMESTAMP,
  status  TEXT,
  PRIMARY KEY ((user), when)
) WITH CLUSTERING ORDER BY (when DESC);
```

<details class="katapod-details"><summary>I want to re-use an Astra DB instance I already have</summary>

If you already have a database (likely with a name other than `zdmtarget`)
and want to use it, that's no problem at all! Just make sure you
[create a new keyspace](https://awesome-astra.github.io/docs/pages/astra/faq/#add-a-keyspace-to-an-existing-database) 
called `zdmapp` in your database and, in case the DB is in the "hibernated" state, please
[resume it](https://awesome-astra.github.io/docs/pages/astra/resume-db/) before moving to next step.

All you have to do then is replacing the name `zdmtarget` with your database
the few times it appears in the console commands for the rest of this scenario.

</details>

#### _🗒️ Your brand new database is created and has the right schema. Now you can start setting up the ZDM process, instructing it to use Astra DB as target._

![Schema, phase 0b](images/schema0b_r.png)

<!-- NAVIGATION -->
<div id="navigation-bottom" class="navigation-bottom">
  <a title="Back" href='command:katapod.loadPage?[{"step":"step1"}]'
    class="btn btn-dark navigation-bottom-left">⬅️ Back
  </a>
  <a title="Next" href='command:katapod.loadPage?[{"step":"step3"}]'
    class="btn btn-dark navigation-bottom-right">Next ➡️
  </a>
</div>
