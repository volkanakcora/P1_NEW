import pandas as pd
import glob
from sqlalchemy import create_engine, engine
import urllib.parse

path_monthly = '/net/testdata1.srv.energy/m7-logs/9sla/syt1/m7_shrd/monthly/*.csv'
path_yearly = '/net/testdata1.srv.energy/m7-logs/9sla/syt1/m7_shrd/yearly/*.csv'


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
    engine = create_engine('postgresql://ebsmadmin:%s@10.139.133.221:26034/ebsm' % urllib.parse.quote('gFp@D*kWZG#r', safe =" "))
    postgres_engine = engine.connect()
    df.to_sql(table_name, con=postgres_engine, index=False, if_exists='replace', method='multi')


#SYT1 Daily
syt1data_monthly = read_csvalues(path_monthly)
send_to_db(syt1data_monthly,'shrdsyt1_monthly')
print("syt1_daily csv has been sent to DB")

#SYT1 Monthly
syt1data_yearly = read_csvalues(path_yearly)
send_to_db(syt1data_yearly,"shrdsyt1_yearly")
print("syt1_yearly csv has been sent to DB")
