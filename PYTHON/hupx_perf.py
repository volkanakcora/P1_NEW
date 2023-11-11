def calculation(data): 
        #Remote Report
        Remote_report = data[data['OrderNames'] == 'OrdrExeRprt']
        Remote_report_percentile998 = np.percentile(Remote_report['Values'],99.8)
        Remote_report_percemtile995 = np.percentile(Remote_report['Values'], 99.5)
        Remote_report_percentiles50 = np.percentile(Remote_report['Values'], 50)
        #Remoot
        Remote_report_0 = data[(data['OrderNames'] == 'OrdrModify') | (data['OrderNames'] == 'OrdrEntry')]
        Remote_report_0 = Remote_report_0[Remote_report_0['Letter'] == 'R']
        Remote_report_0_percentile998 = np.percentile(Remote_report_0['Values'],99.8)
        Remote_report_0_percemtile995 = np.percentile(Remote_report_0['Values'], 99.5)
        Remote_report_0_percentiles50 = np.percentile(Remote_report_0['Values'], 50)
        #Local
        Local_0 = data[data['Letter'] == 'L']
        Local_0["Time"] = pd.to_datetime(Local_0["Time"])
        time = Local_0["Time"].apply(lambda x: x.date())
        time = time.reset_index(drop=True)
        Local_0_percentile998 = np.percentile(Local_0['Values'],99.8)
        Local_0_percemtile995 = np.percentile(Local_0['Values'], 99.5)
        Local_0_percentiles50 = np.percentile(Local_0['Values'], 50)
        return time[0], Local_0_percentiles50 ,Local_0_percemtile995, Local_0_percentile998, Remote_report_0_percentiles50, Remote_report_0_percemtile995, Remote_report_0_percentile998, Remote_report_percentiles50, Remote_report_percemtile995, Remote_report_percentile998
def dataframe(data):
    data = calculation(data)
    data = pd.DataFrame(data).T
    data.rename({0: 'Day ',1: 'Local O 50p ', 2: 'Local O 99,5p', 3: 'Local O 99,8p',4: 'Remote O 50p',5: 'Remote O 99,5p', 6: 'Remote O 99,8p', 7: 'Remote Rprt O 50p',  8: 'Remote Rprt O 99,5p',  9: 'Remote Rprt O 99,8p'}, axis=1, inplace=True)
    return data