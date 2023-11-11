Open BigQuery Console
In the Google Cloud Console, select Navigation menu > BigQuery.
The Welcome to BigQuery in the Cloud Console message box opens. This message box provides a link to the quickstart guide and lists UI updates.

Click Done.


#Task 1. Create a new dataset to store our tables
To create a dataset, click on the View actions icon next to your Project ID and then select Create dataset.


Name the new dataset fruit_store. Leave the other options at their default values (Data Location, Default Table Expiration).

Click Create dataset.


#Task 2. Practice working with Arrays in SQL
Normally in SQL you will have a single value for each row like this list of fruits below:

Row

Fruit

1

raspberry

2

blackberry

3

strawberry

4

cherry


What if you wanted a list of fruit items for each person at the store? It could look something like this:

Row

Fruit

Person

1

raspberry

sally

2

blackberry

sally

3

strawberry

sally

4

cherry

sally

5

orange

frederick

6

apple

frederick


Try it yourself.

Enter the following in the BigQuery Query Editor:

#standardSQL
SELECT
['raspberry', 'blackberry', 'strawberry', 'cherry'] AS fruit_array
Copied!


Now try executing this one:

#standardSQL
SELECT
['raspberry', 'blackberry', 'strawberry', 'cherry', 1234567] AS fruit_array


Arrays can only share one data type (all strings, all numbers).

Here's the final table to query against:

#standardSQL
SELECT person, fruit_array, total_cost FROM `data-to-insights.advanced.fruit_store`;
Copied!
Click Run.


'
#Loading semi-structured JSON into BigQuery


What if you had a JSON file that you needed to ingest into BigQuery?

Create a new table in the fruit_store dataset.
To create a table, click on the View actions icon next to the fruit_store dataset and select Create Table.



Add the following details for the table:

Source: Choose Google Cloud Storage in the Create table from dropdown.

Select file from GCS bucket (type or paste the following): data-insights-course/labs/optimizing-for-performance/shopping_cart.json

File format: JSONL (Newline delimited JSON) {This will be auto-populated}

Schema: Check Auto detect (Schema and input parameters).

Call the new table "fruit_details".

Click Create table.

In the schema, note that fruit_array is marked as REPEATED which means it's an array.


'
#Task 3. Creating your own arrays with ARRAY_AGG()

Copy and Paste the below query to explore this public dataset:

SELECT
  fullVisitorId,
  date,
  v2ProductName,
  pageTitle
  FROM `data-to-insights.ecommerce.all_sessions`
WHERE visitId = 1501570398
ORDER BY date


Now, we will use the ARRAY_AGG() function to aggregate our string values into an array. Copy and paste the below query to explore this public dataset:

SELECT
  fullVisitorId,
  date,
  ARRAY_AGG(v2ProductName) AS products_viewed,
  ARRAY_AGG(pageTitle) AS pages_viewed
  FROM `data-to-insights.ecommerce.all_sessions`
WHERE visitId = 1501570398
GROUP BY fullVisitorId, date
ORDER BY date



Next, we will use the ARRAY_LENGTH() function to count the number of pages and products that were viewed:

SELECT
  fullVisitorId,
  date,
  ARRAY_AGG(v2ProductName) AS products_viewed,
  ARRAY_LENGTH(ARRAY_AGG(v2ProductName)) AS num_products_viewed,
  ARRAY_AGG(pageTitle) AS pages_viewed,
  ARRAY_LENGTH(ARRAY_AGG(pageTitle)) AS num_pages_viewed
  FROM `data-to-insights.ecommerce.all_sessions`
WHERE visitId = 1501570398
GROUP BY fullVisitorId, date
ORDER BY date



Next, let's deduplicate the pages and products so we can see how many unique products were viewed. We'll simply add DISTINCT to our ARRAY_AGG():

SELECT
  fullVisitorId,
  date,
  ARRAY_AGG(DISTINCT v2ProductName) AS products_viewed,
  ARRAY_LENGTH(ARRAY_AGG(DISTINCT v2ProductName)) AS distinct_products_viewed,
  ARRAY_AGG(DISTINCT pageTitle) AS pages_viewed,
  ARRAY_LENGTH(ARRAY_AGG(DISTINCT pageTitle)) AS distinct_pages_viewed
  FROM `data-to-insights.ecommerce.all_sessions`
WHERE visitId = 1501570398
GROUP BY fullVisitorId, date
ORDER BY date




#Task 4. Querying datasets that already have ARRAYs

The BigQuery Public Dataset for Google Analytics bigquery-public-data.google_analytics_sample has many more fields and rows than our course dataset data-to-insights.ecommerce.all_sessions. More importantly, it already stores field values like products, pages, and transactions natively as ARRAYs.

Copy and Paste the below query to explore the available data and see if you can find fields with repeated values (arrays):

SELECT
  *
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
WHERE visitId = 1501570398
'

The amount of fields available in the Google Analytics schema can be overwhelming for our analysis. Let's try to query just the visit and page name fields like we did before:

SELECT
  visitId,
  hits.page.pageTitle
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
WHERE visitId = 1501570398


ou will get an error: Cannot access field product on a value with type ARRAY> at [5:8]

Before we can query REPEATED fields (arrays) normally, you must first break the arrays back into rows.

For example, the array for hits.page.pageTitle is stored currently as a single row like:

['homepage','product page','checkout']
Copied!
and we need it to be:

['homepage',
'product page',
'checkout']






How do we do that with SQL?

Answer: Use the UNNEST() function on your array field:

SELECT DISTINCT
  visitId,
  h.page.pageTitle
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`,
UNNEST(hits) AS h
WHERE visitId = 1501570398
LIMIT 10



#Task 5. Introduction to STRUCTs

Let's explore a dataset with STRUCTs
Under Explorer find the bigquery-public-data dataset.

If it's not present already, click ADD DATA > Pin a project.

Click Enter project name.

Enter bigquery-public-data and click Pin.

Click bigquery-public-data in the pinned project list to expand it.

Find and open google_analytics_sample.

Click the ga_sessions table.

Start scrolling through the schema and answer the following question by using the find feature of your browser (i.e. CTRL + F). Tip: Expand all columns before you begin counting.