import pandas as pd
import glob
from sqlalchemy import create_engine, engine
import urllib.parse

epex_path_monthly = '/net/proddata1.srv.energy/m7-logs/9sla/prod/m7_elts/monthly/*.csv'
epex_path_yearly = '/net/proddata1.srv.energy/m7-logs/9sla/prod/m7_elts/yearly/*.csv'
hupx_path_monthly='/net/proddata1.srv.energy/m7-logs/9sla/prod/m7_hupx/monthly/*.csv'
hupx_path_yearly= '/net/proddata1.srv.energy/m7-logs/9sla/prod/m7_hupx/yearly/*.csv'
opcom_path_monthly = '/net/proddata1.srv.energy/m7-logs/9sla/prod/m7_xrpm/monthly/*.csv'
opcom_path_yearly = '/net/proddata1.srv.energy/m7-logs/9sla/prod/m7_xrpm/yearly/*.csv'
xsop_path_monthly='/net/proddata1.srv.energy/m7-logs/9sla/prod/m7_xsop/monthly/*.csv'
xsop_path_yearly= '/net/proddata1.srv.energy/m7-logs/9sla/prod/m7_xsop/yearly/*.csv'
tge_path_monthly = '/net/proddata1.srv.energy/m7-logs/9sla/prod/m7_plpx/monthly/*.csv'
tge_path_yearly = '/net/proddata1.srv.energy/m7-logs/9sla/prod/m7_plpx/yearly/*.csv'


def read_csvalues(path):
    csv_values = glob.glob(path)
    print(path, 'directory does exist')
    li = []
    for filename in csv_values:
        df = pd.read_csv(filename, sep=';')
        li.append(df)
    frame = pd.concat(li, axis=0, ignore_index=True)
    frame = pd.DataFrame(frame)
    return frame

def send_to_db(df, table_name):
    engine = create_engine('postgresql://ebsmadmin:%s@10.139.135.221:20022/ebsm' % urllib.parse.quote('gFp@D*kWZG#r', safe =" "))
    postgres_engine = engine.connect()
    df.to_sql(table_name, con=postgres_engine, index=False, if_exists='replace', method='multi')


def complete_database_transaction(path_monthly, path_yearly, env, db_table_name_monthly, db_table_name_yarly):
    # Monthly
    data_m = read_csvalues(path_monthly)
    send_to_db(data_m, db_table_name_monthly)
    print(env, "csv has been sent to DB")

    # Yearly
    data_y = read_csvalues(path_yearly)
    send_to_db(data_y, db_table_name_yarly)
    print(env, "csv has been sent to DB")



#EPEX
complete_database_transaction(epex_path_monthly, epex_path_yearly, "EPEX", 'elts_epex_monthly', 'elts_epex_yearly')
#HUPX
complete_database_transaction(hupx_path_monthly, hupx_path_yearly, "HUPX", 'hupx_monthly', 'hupx_yearly')
#OPCOM
complete_database_transaction(opcom_path_monthly, opcom_path_yearly, "OPCOM", 'xrpm_monthly', 'xrpm_yearly')
#XSOP
complete_database_transaction(xsop_path_monthly, xsop_path_yearly, "SouthPool", 'xsop_monthly', 'xsop_yearly')
#TGE
complete_database_transaction(tge_path_monthly, tge_path_yearly, "TGE", 'plpx_monthly', 'plpx_yearly')

