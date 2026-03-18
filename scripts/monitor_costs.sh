#!/bin/bash
# monitor_costs.sh
echo "--- PREVISIÓN DE COSTOS (Infracost) ---"
infracost breakdown --path ../terraform/environments/prod/
