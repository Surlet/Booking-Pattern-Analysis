<h1>Bed & breakfast booking pattern analysis</h1>

<h2>Introduction</h2>

<p>The object of this analysis is the booking data from a bed & breakfast located in Hesbaye region in Belgium. The data comes from the Lighthouse booking software and spans from the opening of the bed & breakfast in 2012 until August 2025. The Hesbaye region is known for its fruit orchards, bucolic landscapes and cycling itineraries. It has become a popular weekend destination for local tourists, mostly coming from other parts of Flanders.</p>

<h2>Objective</h2>

<p>The goal of this analysis is to answer the following questions:</p>
<ol type="1">
  <li>How have the reservations evolved over the years?</li>
  <li>During which seasons, months and on what days does the B&B have more guests?</li>
  <li>Where are the guests coming from?</li>
  <li>When would it be most effective to launch a publicity campaign?</li>
</ol>

<h2>Skills used</h2>
<h3>Excel</h3>
<ul>
  <li>Cleaned raw booking data by identifying and removing duplicates and inconsistent records using filtering techniques</li>
  <li>Enriched data by mapping postal codes to provinces using XLOOKUP, enabling regional analysis</li>
  <li>Performed initial data validation checks to improve data reliability before further analysis</li>
</ul>

<h3>SQL</h3>
<ul>
  <li>Replicated initial data cleaning steps performed in Excel to validate consistency across tools and workflows</li>
  <li>Cleaned and prepared booking data using SQL, including correcting data types (e.g., converting date fields to proper date formats) to ensure accurate time-based analysis</li>
  <li>Created a calendar (date) table to support time-series analysis and enable day-level granularity</li>
  <li>Calculated daily occupancy by joining booking data with the calendar table, applying date range logic to account for stay duration (arrival to departure)</li>
  <li>Aggregated booking data to compute the number of occupied rooms per day, forming the basis for occupancy rate analysis</li>
</ul>

<h3>Power BI</h3>
<ul>
  <li>Transformed and enriched the dataset using <strong>Power Query</strong>, including the creation of calculated columns to support analysis</li>
  <li>Built analytical measures using <strong>DAX</strong> (booking channel distribution) to enable dynamic insights</li>
  <li>Designed clear and effective visualizations (bar charts, line charts, distribution visuals and maps) to highlight key booking trends</li>
  <li>Developed an <strong>interactive dashboard</strong> using buttons and bookmarks, allowing users to explore data across different dimensions (seasonalily, time of the week)</li>
  <li>Structured the report to support intuitive navigation and business-oriented storytelling</li>
</ul>

<h2>Data cleaning</h2>
<h3>Verifying unique values</h3>

<p>While verifying email-adresses, it became clear that a significant amount of reservations had been made with the email-address of the B&B managers. After questioning them, it appears some of these bookings were made because the customer's email-address was unknown, but on other occasions, these bookings were incorrect and subsequently cancelled. Those incorrect bookings are removed from the data. The same was done with rooms booked on the name of the B&B managers.</p>
<p>The criteria used to delete a record was that:</p>
<ul>
  <li>The reservation was made on the name or email of the B&B managers</li>
  <li>The reservation was cancelled or the price was null</li>
</ul>

<p>The next step is to verify the country of the customer. When scanning for the unique values, it appeared there were different values for the same country. Most of the time, the two-letter ISO code was used, but on certain records, the country name was written in full. I corrected those values in order to have conform data. Additionnally, on two occasions, a city name was filled in instead of the country. This was also corrected.</p>
<img width="88" height="285" alt="image" src="https://github.com/user-attachments/assets/2c4cb639-1735-41f7-9195-69b4eb4118e0" />

<p>The column "Postcode" (Postal Code) is also checked and corrected where needed</p>

<h3>Checking null values</h3>

<p>The record with a null price were removed from the dataset.</p>

<h3>Checking double values</h3>

There are no double ID values or double reservations numbers

<h3>Standardising data types</h3>

The data types of the date and price columns were checked, they were all correct.

<h3>Determining the province of origin of Belgian guests</h3>

<p>The XLOOKUP formula was used to compare the postal code to the below table and determine the province of the guest.</p>
<img width="201" height="330" alt="image" src="https://github.com/user-attachments/assets/2d8d2623-dbb4-4082-b04a-482b9c641b28" />



