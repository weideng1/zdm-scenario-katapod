#!/usr/bin/env bash

clear ;

./scenario_scripts/welcome.sh ;

#./scenario_scripts/wait_for_cassandra.sh ;

./scenario_scripts/provision_origin_dse.sh ;

./scenario_scripts/prepare_app_dotenv_dse.sh ;

echo "" ;
echo "   ╔════════════════════╗" ;
echo "   ║  Ready for Step 1  ║" ;
echo "   ╚════════════════════╝" ;
echo "" ;
