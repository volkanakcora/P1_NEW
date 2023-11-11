#!/bin/bash

#Monthly sync
rclone --no-check-certificate --progress copy --max-age 72h --no-traverse --ignore-times  /net/simudata1.srv.energy/m7-logs/9sla/asim/m7_elts/monthly/  sharepoint:/CSV/elts_asim/monthly/
#Yearly sync
rclone --no-check-certificate --progress copy --max-age 72h --no-traverse --ignore-times  /net/simudata1.srv.energy/m7-logs/9sla/asim/m7_elts/yearly/  sharepoint:/CSV/elts_asim/yearly/

#Monthly sync
rclone --no-check-certificate --progress copy --max-age 72h --no-traverse --ignore-times  /net/simudata1.srv.energy/m7-logs/9sla/xsim/m7_elts/monthly/  sharepoint:/CSV/elts_xsim/monthly/
#Yearly sync
rclone --no-check-certificate --progress copy --max-age 72h --no-traverse --ignore-times  /net/simudata1.srv.energy/m7-logs/9sla/xsim/m7_elts/yearly/  sharepoint:/CSV/elts_xsim/yearly/