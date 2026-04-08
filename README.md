<h1>Bed & breakfast booking pattern analysis</h1>

<h2>Introduction</h2>

<p>The object of this analysis is the booking data from a bed & breakfast located in Hesbaye region in Belgium. The data comes from the Lighthouse booking software and spans from the opening of the bed & breakfast in 2012 until August 2025. The Hesbaye region is known for its fruit orchards, bucolic landscapes and cycling itineraries. It has become a popular weekend destination for local tourists, mostly coming from other parts of Flanders.</p>

<h2>Objective</h2>

<p>The goal of this analysis is to answer the following questions:</p>
<ol type="1">
  <li>During which seasons, quarters and on what days does the B&B have more guests?</li>
  <li>How have the reservations evolved over the years?</li>
  <li>Where are the guests coming from?</li>
  <li>When do guests book their stay?</li>
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
  <li>Built analytical measures using <strong>DAX</strong> (booking channel distribution and booking lead time) to enable dynamic insights</li>
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

<h3>Creating a new date table and calculating teh occupancy rating</h3>

<p>In order to train in another tool, I performed the same cleaning steps in SQL with the same original dataset.</p>
<p>In SQL, I created a date dimension table and joined it with the booking data table to calculate the amount of rooms booked on each day, and subsequently to calculate the occupancy rate on each day.</p>

<img width="285" height="347" alt="image" src="https://github.com/user-attachments/assets/d93a134e-3f9c-48f3-b727-cd26dc34323a" />

<h2>Analysis</h2>

<h3>1. During which seasons, quarters and on what days does the B&B have the most guests</h3>

The busiest quarters are the second and third quarters, they make up the high season for the bed & breakfast and accounting for more than 70% of all bookings. Close to 2/3 of rooms booked happen during the weekend as opposed to the working week.

<img width="440" height="246" alt="image" src="https://github.com/user-attachments/assets/f63c9a70-9ddd-4cf0-b458-86ff0d25179c" />
<img width="440" height="179" alt="image" src="https://github.com/user-attachments/assets/ce2cdc6a-bfd9-47d2-a60c-0cd034252ce1" />

<h3>2. How have the reservations evolved over the years?</h3>

<p>A decline of reservations can be seen post-covid. This aligns with the reduction of 6 rooms to 4 that occured in the Summer of 2021. When analysing the trend by seasonality, it appears the decline is stronger in high season, whereas off season, the numbers have remained stable (not taking into account the very succesfull year 2014).</p>

![bookingtrends](https://github.com/user-attachments/assets/96e9333b-7f7e-4008-a869-c507b754845a)

<p>The data also shows that Booking.com has become the most important booking channel in recent years, surpassing 50% of all bookings in 2024.</p>

<img width="442" height="228" alt="image" src="https://github.com/user-attachments/assets/3e6e1b53-3ce2-42e7-9707-c3d7abf942d8" />

<p>When taking a closer look on individual years, a good takeaway is that the most succesful years are characterised by stronger occupancy rates off-season, and during weekdays in high season. This is an example from 2014:</p>

<img width="1236" height="356" alt="image" src="https://github.com/user-attachments/assets/69f9b012-d580-4fd5-87c2-277cb7351ade" />

<h3>Where are the guests coming from?</h3>

The lion's share of the B&B guests come from Belgium, Flanders in particular, and the provinces of Antwerp, East-Flanders and West-Flanders especially. The Netherlands comes as a distant second, Germany and France come in third and fourth.

<img width="1244" height="731" alt="image" src="https://github.com/user-attachments/assets/b721564a-6c6b-420c-a554-8bbb70bcc52d" />

<h3>When do guests book their stay?</h3>

<p>We can identify two very different pattern when examining the booking lead times, depending on the type of guest. Guests who reserve for a weekend stay usually book a long time in advance. Close to 40% book more than a month in advance, with almost 30% booking more than a week in advance. The profile of this type of guest is either a tourist enjoying a weekend in nature or people attening a wedding or other celebration on a Saturday.</p>

<p>The guest coming on weekdays, has a very different profile. They are often professionals coming from far way working on projects spanning multiple days, and needing a place to sleep. Most of the time, they will book their stay last minute. Especially off-season, 30% of weekday guests make their reservation on the same day.</p>

![bookingleadtime](https://github.com/user-attachments/assets/846fe388-c3cf-433a-a7c4-c5e18b2ab879)

<h2>Conclusion</h2>

<p>After two rooms out of six rooms were closed in 2021, the business has logically experienced a decline in the amount of rooms booked. This decline has been more significant on weekends in high season, because the six rooms used to be filled easily and this is where closing the two additional rooms hurts the most. There is however potential for growth on weekdays, and especially off-season. As discussed the best year where characterised by a higher occupancy rates on weekdays and off-season.</p>

<h2>Recommendation</h2>

<p>Here are a few recommendations to drive growth:</p>

<ul>
  <li>Make partnerships with companies to attract more workers off-season</li>
  <li>Make partnerships with wedding venues to attract more people on weekens off season</li>
  <li>Launch a publicity campaign in the beginning of the year, that can target both workers making last-minute reservations as well as tourists planning their vacation ahead.</li>
  <li>Target a Flemish public, as the vast majority of the guests come from Flanders.</li>
  <li>Consider renewing the website and promoting it, to avoid a depency on Booking.com for reservations.</li>
</ul>



