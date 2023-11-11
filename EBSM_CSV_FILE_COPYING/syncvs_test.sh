#!/bin/bash

dirSYT1_monthly= "/net/testdata1.srv.energy/m7-logs/9sla/syt1/m7_shrd/monthly"
dirmonthly_dest= "sharepoint:/CSV/shrd_syt1/monthly"
dirSYT1_yearly= "/net/testdata1.srv.energy/m7-logs/9sla/syt1/m7_shrd/yearly"
diryearly_dest= "sharepoint:/CSV/shrd_syt1/yearly"


#Monthly sync
rclone --no-check-certificate sync $dirSYT1_monthly $dirmonthly_dest
#Yearly sync
rclone --no-check-certificate sync $dirSYT1_yearl  $diryearly_dest




prrof of concenpt: 

#!/bin/bash

#dirSYT1_monthly= /net/testdata1.srv.energy/m7-logs/9sla/syt1/m7_shrd/monthly/
#dirmonthly_dest= /CSV/shrd_syt1/monthly/
#dirSYT1_yearly= '/net/testdata1.srv.energy/m7-logs/9sla/syt1/m7_shrd/yearly/'
#diryearly_dest= 'sharepoint:/CSV/shrd_syt1/yearly/'


#Monthly sync
rclone --no-check-certificate sync  /net/testdata1.srv.energy/m7-logs/9sla/syt1/m7_shrd/monthly/  sharepoint:/CSV/shrd_syt1/monthly/
#Yearly sync
rclone --no-check-certificate sync  /net/testdata1.srv.energy/m7-logs/9sla/syt1/m7_shrd/yearly/   sharepoint:/CSV/shrd_syt1/yearly/




#!/bin/bash

#EPEX Monthly sync
rclone --no-check-certificate sync  /net/proddata1.srv.energy/m7-logs/9sla/prod/m7_elts/monthly/*  sharepoint:/CSV/elts_prod/monthly/*
#EPEX Yearly sync
rclone --no-check-certificate sync  /net/proddata1.srv.energy/m7-logs/9sla/prod/m7_elts/yearly/  sharepoint:/CSV/elts_prod/yearly/

#HUPX Monthly sync
rclone --no-check-certificate sync  /net/proddata1.srv.energy/m7-logs/9sla/prod/m7_hupx/monthly/  sharepoint:/CSV/hupx_prod/monthly/
#HUPX Yearly sync
rclone --no-check-certificate sync  /net/proddata1.srv.energy/m7-logs/9sla/prod/m7_hupx/yearly/  sharepoint:/CSV/hupx_prod/yearly/


#PLPX Monthly sync
rclone --no-check-certificate sync  /net/proddata1.srv.energy/m7-logs/9sla/prod/m7_plpx/monthly/  sharepoint:/CSV/plpx_prod/monthly/
#PLPX Yearly sync
rclone --no-check-certificate sync  /net/proddata1.srv.energy/m7-logs/9sla/prod/m7_plpx/yearly/  sharepoint:/CSV/plpx_prod/yearly/


#XRPM  Monthly sync
rclone --no-check-certificate sync  /net/proddata1.srv.energy/m7-logs/9sla/prod/m7_xrpm/monthly/  sharepoint:/CSV/xrpm_prod/monthly/
#XRPM  Yearly sync
rclone --no-check-certificate sync  /net/proddata1.srv.energy/m7-logs/9sla/prod/m7_xrpm/yearly/  sharepoint:/CSV/xrpm_prod/yearly/


#XSOP  Monthly sync
rclone --no-check-certificate sync  /net/proddata1.srv.energy/m7-logs/9sla/prod/m7_xsop/monthly/  sharepoint:/CSV/xsop_prod/monthly/
#XSOP  Yearly sync
rclone --no-check-certificate sync  /net/proddata1.srv.energy/m7-logs/9sla/prod/m7_xsop/yearly/  sharepoint:/CSV/xsop_prod/yearly/

