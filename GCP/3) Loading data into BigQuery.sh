Open BigQuery Console
In the Google Cloud Console, select Navigation menu > BigQuery.

#Task 1. Create a new dataset to store tables

1) To create a dataset, click on the View actions icon (the three vertical dots) next to your project ID and select Create dataset.

2) Next, name your Dataset ID nyctaxi and leave all other options at their default values, and then click Create dataset.

Youll now see the nyctaxi dataset under your project name.



#Task 2. Ingest a new dataset from a CSV

In this section, you will load a local CSV into a BigQuery table.

Download a subset of the NYC taxi 2018 trips data locally onto your computer from this link.

In the BigQuery Console, Select the nyctaxi dataset then click Create Table



Specify the below table options:

Source:

Create table from: Upload
Choose File: select the file you downloaded locally earlier
File format: CSV
Destination:

Table name: 2018trips Leave all other settings at default.
Schema:

Check Auto Detect (tip: Not seeing the checkbox? Ensure the file format is CSV and not Avro)
Advanced Options

Leave at default values
Click Create Table.



Select the 2018trips table and view details:

SELECT * FROM `qwiklabs-gcp-04-845c98616991.nyctaxi.2018trips` 



#Running SQL Queries

Next, practice with a basic query on the 2018trips table.

In the Query Editor, write a query to list the top 5 most expensive trips of the year:

#standardSQL
SELECT
  *
FROM
  nyctaxi.2018trips
ORDER BY
  fare_amount DESC
LIMIT  5



#Task 3. Ingest a new dataset from Google Cloud Storage

Now, lets try to load another subset of the same 2018 trip data that is available on Cloud Storage. And this time, let's use the CLI tool to do it.

In your Cloud Shell, run the following command :
bq load \
--source_format=CSV \
--autodetect \
--noreplace  \
nyctaxi.2018trips \
gs://cloud-training/OCBL013/nyc_tlc_yellow_trips_2018_subset_2.csv

Note: With the above load job, you are specifying that this subset is to be appended to the existing 2018trips table that you created above.

When the load job is complete, you will get a confirmation on the screen.

Back on your BigQuery console, select the 2018trips table and view details. Confirm that the row count has now almost doubled.

You may want to run the same query like earlier to see if the top 5 most expensive trips have changed.
'


#Task 4. Create tables from other tables with DDL

The 2018trips table now has trips from throughout the year. What if you were only interested in January trips? For the purpose of this lab, we will keep it simple and focus only on pickup date and time. Let's use DDL to extract this data and store it in another table

In the Query Editor, run the following CREATE TABLE command'


#standardSQL
CREATE TABLE
  nyctaxi.january_trips AS
SELECT
  *
FROM
  nyctaxi.2018trips
WHERE
  EXTRACT(Month
  FROM
    pickup_datetime)=1;


Now run the below query in your Query Editor find the longest distance traveled in the month of January:

#standardSQL
SELECT
  *
FROM
  nyctaxi.january_trips
ORDER BY
  trip_distance DESC
LIMIT
  1