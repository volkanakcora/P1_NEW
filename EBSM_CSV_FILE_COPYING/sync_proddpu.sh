#!/bin/bash

#EPEX Monthly sync
rclone --no-check-certificate --progress copy --max-age 72h --no-traverse --ignore-times  /net/proddata1.srv.energy/m7-logs/9sla/prod/m7_elts/monthly/  sharepoint:/CSV/elts_prod/monthly/
#EPEX Yearly sync
rclone --no-check-certificate --progress copy --max-age 72h --no-traverse --ignore-times  /net/proddata1.srv.energy/m7-logs/9sla/prod/m7_elts/yearly/  sharepoint:/CSV/elts_prod/yearly/

#HUPX Monthly sync
rclone --no-check-certificate --progress copy --max-age 72h --no-traverse --ignore-times  /net/proddata1.srv.energy/m7-logs/9sla/prod/m7_hupx/monthly/  sharepoint:/CSV/hupx_prod/monthly/
#HUPX Yearly sync
rclone --no-check-certificate --progress copy --max-age 72h --no-traverse --ignore-times  /net/proddata1.srv.energy/m7-logs/9sla/prod/m7_hupx/yearly/  sharepoint:/CSV/hupx_prod/yearly/

#PLPX Monthly sync
rclone --no-check-certificate --progress copy --max-age 72h --no-traverse --ignore-times  /net/proddata1.srv.energy/m7-logs/9sla/prod/m7_plpx/monthly/  sharepoint:/CSV/plpx_prod/monthly/
#PLPX Yearly sync
rclone --no-check-certificate --progress copy --max-age 72h --no-traverse --ignore-times  /net/proddata1.srv.energy/m7-logs/9sla/prod/m7_plpx/yearly/  sharepoint:/CSV/plpx_prod/yearly/

#XRPM  Monthly sync
rclone --no-check-certificate --progress copy --max-age 72h --no-traverse --ignore-times  /net/proddata1.srv.energy/m7-logs/9sla/prod/m7_xrpm/monthly/  sharepoint:/CSV/xrpm_prod/monthly/
#XRPM  Yearly sync
rclone --no-check-certificate --progress copy --max-age 72h --no-traverse --ignore-times  /net/proddata1.srv.energy/m7-logs/9sla/prod/m7_xrpm/yearly/  sharepoint:/CSV/xrpm_prod/yearly/

#XSOP  Monthly sync
rclone --no-check-certificate --progress copy --max-age 72h --no-traverse --ignore-times  /net/proddata1.srv.energy/m7-logs/9sla/prod/m7_xsop/monthly/  sharepoint:/CSV/xsop_prod/monthly/
#XSOP  Yearly sync
rclone --no-check-certificate --progress copy --max-age 72h --no-traverse --ignore-times  /net/proddata1.srv.energy/m7-logs/9sla/prod/m7_xsop/yearly/  sharepoint:/CSV/xsop_prod/yearly/