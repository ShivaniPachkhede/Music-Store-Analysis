CREATE DATABASE music_store;

## QUESTION SET 1 - EASY ##

-- Q1 Who is the senior most employee based on job title?
select * from employee;
select levels, title, concat(first_name,last_name) as employee_name
from employee
order by levels desc
limit 1;

-- Q2 Which country have the most invoices
select * from invoice;
select billing_country, count(invoice_id) as total_invoice
from invoice
group by billing_country
order by total_invoice desc;

-- Q3 what are top 3 values of total invoices?
select * from invoice;
select invoice_id, round(total) as total_invoices
from invoice
order by total desc
limit 3;

-- Q4 Which city has the best customers? We would like to through a promotional Music Festival in city we made the most money
-- Write a query that returns one city that has the highest sum of invoice totals.
-- Return both the city name and sum of all invoice totals.
select * from invoice;
select billing_city as city_name, round(sum(total)) as invoice_total
from invoice
group by city_name
order by invoice_total desc
limit 1;

-- Q5 Who is the best customer? The customer who has spent the most money will be declared the best customer.
-- Write a query that returns the person who has spent most money.
select* from invoice;
select * from customer;
select concat(c.first_name,c.last_name) as Customer_name, round(sum(total)) as money_spent
from customer as c
join invoice as i on i.customer_id= c.customer_id
group by Customer_name
order by money_spent
limit 1;

## QUESTION SET 2 - MODERATE ##

-- Q1 Write query to return email, first name, last name & Genre of Rock Music listners.
-- Return your list by alphabetically by email starting with A.
Select * from customer;
Select * from genre;
Select * from invoice;
Select * from track;
select * from invoice_line;
select distinct c.email, c.first_name, c.last_name, g.name as genre_name
from customer c
join invoice i on c.customer_id=i.customer_id
join invoice_line il on i.invoice_id=il.invoice_id
join track t on il.track_id=t.track_id
join genre g on t.genre_id=g.genre_id
where g.name= "Rock"
order by c.email;

-- Q2 Lets invite the artists who have written most rock music in our dataset.
-- Write a query that returns Artist name and total track count of the top 10 rock bands.
select ar.name as artist_name, count(track_id) as total_track
from track t
join album2 a on t.album_id=a.album_id
join artist ar on a.artist_id=ar.artist_id
where genre_id= 1
group by artist_name
order by total_track desc
limit 10;

-- Q3 Return all the track names that have a song length longer than the average song length.
-- Return the name and Milliseconds for each track. 
-- Order by the song lenght with the longest songs listed first.
Select * from track;
select name as track_name, milliseconds
from track
where milliseconds > (select avg(milliseconds) as avg from track)
order by milliseconds desc;

## QUESTION SET 3 - ADVANCE ##

-- Q1 Find how much amount spend by each customer on artists?
-- Write a query to return customer name, artist name and total spent.
Select * from customer; 
Select * from invoice; 
Select * from track; 
Select * from artist; 
Select * from invoice_line; 
Select * from album2; 
select c.customer_id, concat(c.first_name,c.last_name) as customer_name, 
ar.name as artist_name, sum(il.unit_price*il.quantity) as total_spent
from customer c
join invoice i on c.customer_id=i.customer_id
join invoice_line il on i.invoice_id=il.invoice_id
join track t on il.track_id=t.track_id
join album2 a on t.album_id=a.album_id
join artist ar on a.artist_id=ar.artist_id
group by 1,2,3
order by artist_name,total_spent desc;

-- Q2 We want to find out most popular Music Genre for each country.
-- We determine the most popular genre as the genre with the highest amount of purchase.
-- Write a query that returns each country along with the top Genre.
-- For countries where the maximum number of purchases is shared return all genres
Select * from genre; 
Select * from track; 
Select * from invoice; 
Select * from invoice_line;
With a as(select i.billing_country,g.name as genre_name, count(il.quantity) as total_purchase, 
rank()over(partition by i.billing_country order by count(il.quantity)desc) as rank_1
from invoice i
join invoice_line il on i.invoice_id=il.invoice_id
join track t on il.track_id=t.track_id
join genre g on g.genre_id=t.genre_id
group by 1,2
order by i.billing_country asc , count(il.quantity) desc) 
select * from a 
where rank_1 =1
order by total_purchase desc;

-- Q3 Write a query that determines the customer that has spent on music for each country.
-- Write a query that returns a country along with the top customer and how much they spent.
-- For countries the top amount is shared, provide all customers who spent this amount
Select * from customer;
Select * from invoice;
with a as (
select c.country, concat(c.first_name,c.last_name) as customer_name, round(sum(i.total)) as spent,
rank()over(partition by c.country order by round(sum(total))) as spent_rank
from customer c
join invoice i on c.customer_id=i.customer_id
group by 1,2
order by c.country asc, spent desc
)
select * from a 
where spent_rank =1
order by spent desc;