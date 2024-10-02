[root@m7shrdebsm1 pmi_epex]# cat pmi_parse.ipynb 
import glob 
import pandas as pd 

file_path= '*.log' 

def read_logs(path):
    strings = ('17:05', '17:06', '17:07')
    epex_log = []
    log_files = glob.glob(path)
    for filename in log_files:
        with open(filename, 'r') as f:
            for line in f:
                if any(s in line for s in strings):
                    epex_log.append(line)
    

    return epex_log


epex_log = read_logs(file_path)





epex_log = pd.DataFrame(epex_log)
print(epex_log.count())
epex_log.to_csv('epex_pmi_logsi_1705.csv')
