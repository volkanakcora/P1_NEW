#Activate Google Cloud Shell

Google Cloud Shell is a virtual machine that is loaded with development tools. It offers a persistent 5GB home directory and runs on the Google Cloud.

Google Cloud Shell provides command-line access to your Google Cloud resources.

In Cloud console, on the top right toolbar, click the Open Cloud Shell button.




It takes a few moments to provision and connect to the environment. When you are connected, you are already authenticated, and the project is set to your PROJECT_ID. For example:

Project ID highlighted in the Cloud Shell Terminal

gcloud is the command-line tool for Google Cloud. It comes pre-installed on Cloud Shell and supports tab-completion.

You can list the active account name with this command:
gcloud auth list



You can list the project ID with this command:
gcloud config list project


#Task 1. Lift and shift


Migrate existing Spark jobs to Cloud Dataproc

You will create a new Cloud Dataproc cluster and then run an imported Jupyter notebook that uses the cluster's default local Hadoop Distributed File 
system (HDFS) to store source data and then process that data just as you would on any Hadoop cluster using Spark. This demonstrates how many existing analytics 
workloads such as Jupyter notebooks containing Spark code require no changes when they are migrated to a Cloud Dataproc environment.

'
!Configure and start a Cloud Dataproc cluster


in the GCP Console, on the Navigation menu, in the Analytics section, click Dataproc.

Click Create Cluster.

Click Create for the item Cluster on Compute Engine.

Enter sparktodp for Cluster Name.

In the Versioning section, click Change and select 2.1 (Debian 11, Hadoop 3.3, Spark 3.3).

This version includes Python3, which is required for the sample code used in this lab.

Click Select.

In the Components > Component gateway section, select Enable component gateway.

Under Optional components, Select Jupyter Notebook.

Below Set up cluster from the list on the left side, click Configure nodes (optional).

Under Manager node change Series to E2 and Machine Type to e2-standard-2 (2 vCPU, 8 GB memory).

Under Worker nodes change Series to E2 and Machine Type to e2-standard-2 (2 vCPU, 8 GB memory).

Click Create.




#Clone the source repository for the lab

1) In the Cloud Shell you clone the Git repository for the lab and copy the required notebook files to the Cloud Storage bucket used by Cloud Dataproc as the home directory for Jupyter notebooks.

To clone the Git repository for the lab enter the following command in Cloud Shell:

git -C ~ clone https://github.com/GoogleCloudPlatform/training-data-analyst


2) To locate the default Cloud Storage bucket used by Cloud Dataproc enter the following command in Cloud Shell:

export DP_STORAGE="gs://$(gcloud dataproc clusters describe sparktodp --region=us-central1 --format=json | jq -r '.config.configBucket')"

3) To copy the sample notebooks into the Jupyter working folder enter the following command in Cloud Shell:

gsutil -m cp ~/training-data-analyst/quests/sparktobq/*.ipynb $DP_STORAGE/notebooks/jupyter


#Log in to the Jupyter Notebook

1) On the Dataproc Clusters page wait for the cluster to finish starting and then click the name of your cluster to open the Cluster details page.

2) Click Web Interfaces.

3) Click the Jupyter link to open a new Jupyter tab in your browser.

4) This opens the Jupyter home page. Here you can see the contents of the /notebooks/jupyter directory in Cloud Storage that now includes the sample Jupyter notebooks used in this lab.

5) Under the Files tab, click the GCS folder and then click 01_spark.ipynb notebook to open it.

6) Click Cell and then Run All to run all of the cells in the notebook.

7) Page back up to the top of the notebook and follow as the notebook completes runs each cell and outputs the results below them.



8) The first code cell fetches the source data file, which is an extract from the KDD Cup competition from the Knowledge, Discovery, and Data (KDD) conference in 1999. The data relates to computer intrusion detection events.

!wget https://storage.googleapis.com/cloud-training/dataengineering/lab_assets/sparklab/kddcup.data_10_percent.gz
Copied!


9) In the second code cell, the source data is copied to the default (local) Hadoop file system.

!hadoop fs -put kddcup* /


In the third code cell, the command lists contents of the default directory in the cluster's HDFS file system.

!hadoop fs -ls /


'
#Reading in data
The data are gzipped CSV files. In Spark, these can be read directly using the textFile method and then parsed by splitting each row on commas.

In this cell Spark SQL is initialized and Spark is used to read in the source data as text and then returns the first 5 rows.

from pyspark.sql import SparkSession, SQLContext, Row
spark = SparkSession.builder.appName("kdd").getOrCreate()
sc = spark.sparkContext
data_file = "hdfs:///kddcup.data_10_percent.gz"
raw_rdd = sc.textFile(data_file).cache()
raw_rdd.take(5)



In cell In [5] each row is split, using , as a delimiter and parsed using a prepared inline schema in the code.


csv_rdd = raw_rdd.map(lambda row: row.split(","))
parsed_rdd = csv_rdd.map(lambda r: Row(
    duration=int(r[0]),
    protocol_type=r[1],
    service=r[2],
    flag=r[3],
    src_bytes=int(r[4]),
    dst_bytes=int(r[5]),
    wrong_fragment=int(r[7]),
    urgent=int(r[8]),
    hot=int(r[9]),
    num_failed_logins=int(r[10]),
    num_compromised=int(r[12]),
    su_attempted=r[14],
    num_root=int(r[15]),
    num_file_creations=int(r[16]),
    label=r[-1]
    )
)
parsed_rdd.take(5)



#Spark analysis

Row data can be selected and displayed using the dataframes .show() method to output a view summarizing a count of selected fields

sqlContext = SQLContext(sc)
df = sqlContext.createDataFrame(parsed_rdd)
connections_by_protocol = df.groupBy('protocol_type').count().orderBy('count', ascending=False)
connections_by_protocol.show()



The last cell, In [8] uses the %matplotlib inline Jupyter magic function to redirect matplotlib to render a graphic figure inline in the notebook instead of just dumping the data into a variable. This cell displays a bar chart using the attack_stats query from the previous step.


%matplotlib inline
ax = attack_stats.toPandas().plot.bar(x='protocol_type', subplots=True, figsize=(10,25))


#Task 2. Separate compute and storage



Modify Spark jobs to use Cloud Storage instead of HDFS

Taking this original 'Lift & Shift' sample notebook you will now create a copy that decouples the storage requirements for the job from the compute requirements. 
In this case, all you have to do is replace the Hadoop file system calls with Cloud Storage calls by replacing hdfs:// storage references with gs:// references in the code and adjusting folder names as necessary.

1) In the Cloud Shell create a new storage bucket for your source data:


export PROJECT_ID=$(gcloud info --format='value(config.project)')
gsutil mb gs://$PROJECT_ID


2) In the Cloud Shell copy the source data into the bucket:

wget https://storage.googleapis.com/cloud-training/dataengineering/lab_assets/sparklab/kddcup.data_10_percent.gz
gsutil cp kddcup.data_10_percent.gz gs://$PROJECT_ID/

Switch back to the 01_spark Jupyter Notebook tab in your browser.

Click File and then select Make a Copy.

When the copy opens, click the 01_spark-Copy1 title and rename it to De-couple-storage.

Open the Jupyter tab for 01_spark.

Click File and then Save and checkpoint to save the notebook.

Click File and then Close and Halt to shutdown the notebook.

If you are prompted to confirm that you want to close the notebook click Leave or Cancel.

Switch back to the De-couple-storage Jupyter Notebook tab in your browser, if necessary.
You no longer need the cells that download and copy the data onto the cluster's internal HDFS file system so you will remove those first.

To delete a cell, you click in the cell to select it and then click the cut selected cells icon (the scissors) on the notebook toolbar.

Delete the initial comment cells and the first three code cells ( In [1], In [2], and In [3]) so that the notebook now starts with the section Reading in Data.
You will now change the code in the first cell ( still called In[4] unless you have rerun the notebook ) that defines the data file source location and reads in the source data. The cell currently contains the following code:

'
from pyspark.sql import SparkSession, SQLContext, Row
spark = SparkSession.builder.appName("kdd").getOrCreate()
sc = spark.sparkContext
data_file = "hdfs:///kddcup.data_10_percent.gz"
raw_rdd = sc.textFile(data_file).cache()
raw_rdd.take(5)



#Task 3. Deploy Spark jobs

In the De-couple-storage Jupyter Notebook menu, click File and select Make a Copy.

When the copy opens, click the De-couple-storage-Copy1 and rename it to PySpark-analysis-file.

Open the Jupyter tab for De-couple-storage.

Click File and then Save and checkpoint to save the notebook.

Click File and then Close and Halt to shutdown the notebook.

If you are prompted to confirm that you want to close the notebook click Leave or Cancel.

Switch back to the PySpark-analysis-file Jupyter Notebook tab in your browser, if necessary.

Click the first cell at the top of the notebook.

Click Insert and select Insert Cell Above.

Paste the following library import and parameter handling code into this new first code cell:


For the remaining cells insert %%writefile -a spark_analysis.py at the start of each Python code cell. These are the five cells labelled In [x].



#Make sure you have selected the last code cell in the notebook then, in the menu bar, click Insert and select Insert Cell Below.

Paste the following code into the new cell:

%%writefile -a spark_analysis.py
ax[0].get_figure().savefig('report.png');


#Add another new cell at the end of the notebook and paste in the following:

%%writefile -a spark_analysis.py
import google.cloud.storage as gcs
bucket = gcs.Client().get_bucket(BUCKET)
for blob in bucket.list_blobs(prefix='sparktodp/'):
    blob.delete()
bucket.blob('sparktodp/report.png').upload_from_



#Add a new cell at the end of the notebook and paste in the following:

%%writefile -a spark_analysis.py
connections_by_protocol.write.format("csv").mode("overwrite").save(
    "gs://{}/sparktodp/connections_by_protocol".format(BUCKET))




###Test automation


You now test that the PySpark code runs successfully as a file by calling the local copy from inside the notebook, passing in a parameter to 
identify the storage bucket you created earlier that stores the input data for this job. The same bucket will be used to store the report data files produced by the script.


1) In the PySpark-analysis-file notebook add a new cell at the end of the notebook and paste in the following:
BUCKET_list = !gcloud info --format='value(config.project)'
BUCKET=BUCKET_list[0]
print('Writing to {}'.format(BUCKET))
!/opt/conda/miniconda3/bin/python spark_analysis.py --bucket=$BUCKET


This code assumes that you have followed the earlier instructions and created a Cloud Storage Bucket using your lab Project ID as the Storage Bucket name. If you used a different name modify this code to set the BUCKET variable to the name you used.


2)Add a new cell at the end of the notebook and paste in the following:

!gsutil ls gs://$BUCKET/sparktodp/**

This lists the script output files that have been saved to your Cloud Storage bucket.

3) To save a copy of the Python file to persistent storage, add a new cell and paste in the following:
!gsutil cp spark_analysis.py gs://$BUCKET/sparktodp/spark_analysis.py



#Run the Analysis Job from Cloud Shell.

gsutil cp gs://$PROJECT_ID/sparktodp/spark_analysis.py spark_analysis.py

Create a launch script:

nano submit_onejob.sh
Copied!