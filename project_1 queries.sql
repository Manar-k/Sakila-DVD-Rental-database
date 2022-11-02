/*Name: Manar Khamees*/

/*Q1: 
Create a query that lists each movie, the film category it is classified in, 
and the number of times it has been rented out.*/
/*Query 1 - query used for first insight*/
WITH T1 AS(SELECT category_id, name AS family
             FROM category 
             WHERE name = 'Animation' OR name = 'Children' 
                OR name = 'Classics' OR name = 'Comedy' 
                OR name = 'Family' OR name = 'Music')
SELECT f.title, c.family, COUNT(r.* ) AS Rentals
  FROM film_category f_c
  JOIN film f
    ON f.film_id = f_c.film_id
  JOIN T1 c
    ON c.category_id  = f_c.category_id
  JOIN inventory i
    ON i.film_id = f.film_id
  JOIN rental r
    ON r.inventory_id = i.inventory_id
 GROUP BY 1,2
 ORDER BY 2,1;

/*Q2: 
Can you provide a table with the movie titles and divide them into 4 levels (first_quarter, 
second_quarter, third_quarter, and final_quarter) based on the quartiles (25%, 50%, 75%) of 
the rental duration for movies across all categories?*/
/*Query 2 - query used for second insight*/
WITH T1 AS(SELECT category_id, name
           FROM category
           WHERE name = 'Animation' OR name = 'Children' 
           OR name = 'Classics' OR name = 'Comedy'
           OR name = 'Family' OR name = 'Music')
SELECT f.title, c.name, f.rental_duration, NTILE(4) OVER ( ORDER BY f.rental_duration) AS standard_quartile
FROM film_category f_c
JOIN film f
  ON f.film_id = f_c.film_id
JOIN T1 c
  ON c.category_id  = f_c.category_id
ORDER BY 3;

/*Q3: 
Provide a table with the family-friendly film category, each of the quartiles, and the 
corresponding count of movies within each combination of film category for each 
corresponding rental duration category.*/
/*Query 3 - query used for third insight*/
WITH T1 AS(SELECT category_id, name
             FROM category
             WHERE name = 'Animation' OR name = 'Children' 
             OR name = 'Classics' OR name = 'Comedy'
             OR name = 'Family' OR name = 'Music'),
     T2 AS (SELECT f.title, c.name, f.rental_duration, NTILE(4) OVER ( ORDER BY f.rental_duration) AS standard_quartile
              FROM film_category f_c
              JOIN film f
                ON f.film_id = f_c.film_id
              JOIN T1 c
                ON c.category_id  = f_c.category_id
              ORDER BY 3)
SELECT t2.name, t2.standard_quartile, COUNT(*)
  FROM T2 t2
GROUP BY 1,2
ORDER BY 1,2;

/*Q4: 
Write a query that returns the store ID for the store, the year and month and the number of rental orders 
each store has fulfilled for that month. Your table should include a column for each of the following: year, 
month, store ID and count of rental orders fulfilled during that month.*/
/*Query 4 - query used for fourth insight*/
SELECT DATE_PART('month',r.rental_date) AS rental_month, 
       DATE_PART('year',r.rental_date) AS rental_year, s.store_id, COUNT(r.rental_date) AS count_rentals
  FROM rental r
  JOIN staff st
    ON st.staff_id = r.staff_id
  JOIN store s
    ON s.store_id = st.store_id
GROUP BY 1,2,3
ORDER BY 4 DESC;