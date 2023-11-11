#!/bin/bash

#Monthly sync
rclone --no-check-certificate --progress copy --max-age 72h --no-traverse --ignore-times  /net/testdata1.srv.energy/m7-logs/9sla/syt1/m7_shrd/monthly/  sharepoint:/CSV/shrd_syt1/monthly/
#Yearly sync
rclone --no-check-certificate --progress copy --max-age 72h --no-traverse --ignore-times  /net/testdata1.srv.energy/m7-logs/9sla/syt1/m7_shrd/yearly/   sharepoint:/CSV/shrd_syt1/yearly/