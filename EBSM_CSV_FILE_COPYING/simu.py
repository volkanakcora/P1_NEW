import pandas as pd
import glob
from sqlalchemy import create_engine, engine
import urllib.parse

asim_path_monthly = '/net/simudata1.srv.energy/m7-logs/9sla/asim/m7_elts/monthly/*.csv'
asim_path_yearly = '/net/simudata1.srv.energy/m7-logs/9sla/asim/m7_elts/yearly/*.csv'
xsim_path_monthly='/net/simudata1.srv.energy/m7-logs/9sla/xsim/m7_elts/monthly/*.csv'
xsim_path_yearly= '/net/simudata1.srv.energy/m7-logs/9sla/xsim/m7_elts/yearly/*.csv'


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
    engine = create_engine('postgresql://ebsmadmin:%s@10.139.134.221:24062/ebsm' % urllib.parse.quote('gFp@D*kWZG#r', safe =" "))
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



#ASIM 
complete_database_transaction(asim_path_monthly, asim_path_yearly, "ASIM", 'elts_asim_monthly', 'elts_asim_yearly')
#XSIM
complete_database_transaction(xsim_path_monthly, xsim_path_yearly, "XSIM", 'elts_xsim_monthly', 'elts_xsim_yearly')

