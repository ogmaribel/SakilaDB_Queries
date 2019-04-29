USE sakila;

-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT concat(first_name, " ",last_name) as actor_name FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe.
-- " What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name FROM actor WHERE first_name="JOE";

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT first_name, last_name FROM actor WHERE last_name LIKE "%GEN%";

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT  last_name, first_name FROM actor WHERE last_name LIKE "%LIcountry%";

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country FROM country WHERE country IN ("Afghanistan", "Bangladesh", "China");

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description,
-- so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, 
-- as the difference between it and VARCHAR are significant).
ALTER TABLE actor ADD description BLOB AFTER last_name;
SELECT * FROM actor; 

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE actor DROP description ;
SELECT * FROM actor; 

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) AS num FROM actor GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(*) AS num FROM actor  GROUP BY last_name HAVING num >= 2; 

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor 
SET 
    first_name = "HARPO"
WHERE
    first_name="GROUCHO" AND last_name="WILLIAMS";

SELECT actor_id, first_name, last_name FROM actor WHERE first_name="HARPO" AND last_name="WILLIAMS";

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
-- It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, 
-- change it to GROUCHO.
UPDATE actor 
SET 
    first_name = "GROUCHO"
WHERE
    first_name="HARPO" AND last_name="WILLIAMS";

SELECT actor_id, first_name, last_name FROM actor WHERE first_name="GROUCHO" AND last_name="WILLIAMS";

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT s.first_name, s.last_name, a.address
FROM staff as s
INNER JOIN address as a ON s.address_id= a.address_id ;


-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT s.staff_id, s.first_name, s.last_name, SUM(p.amount) AS total_amount
FROM staff as s
INNER JOIN payment as p ON s.staff_id= p.staff_id 
WHERE p.payment_date LIKE "%2005-08%"
GROUP BY staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT  f.title, count(fa.actor_id) as number_of_actors
FROM film_actor as fa
INNER JOIN film as f ON fa.film_id= f.film_id 
GROUP BY title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT  f.title, count(f.title) as number_of_copies
FROM film as f
INNER JOIN inventory as i ON f.film_id= i.film_id 
GROUP BY title
HAVING title = "Hunchback Impossible";

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name:
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_paid
FROM customer as c 
LEFT JOIN payment as p ON c.customer_id = p.customer_id
GROUP BY first_name, last_name
ORDER BY last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence.
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

SELECT title
FROM film
WHERE (title LIKE "K%" OR title LIKE "Q%") 
	AND language_id = (SELECT language_id FROM language WHERE name="English");

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
-- NOTE: "=" can be used when the subquery returns only 1 value instead use "IN"
SELECT first_name, last_name
FROM actor
WHERE actor_id
	IN (SELECT actor_id FROM film_actor WHERE film_id 
		IN (SELECT film_id from film WHERE title="ALONE TRIP"));
-- 7c. You want to run an email marketing campaign in Canada, 
-- for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
-- QUESTION: How to remove country
SELECT c.first_name, c.last_name, c.email, country.country
FROM customer as c
INNER JOIN address as a ON c.address_id= a.address_id 
INNER JOIN city as city ON a.city_id= city.city_id 
INNER JOIN country as country ON city.country_id= country.country_id 
HAVING(country="Canada");

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
-- QUESTION: How to remove name
SELECT f.title, c.name
FROM film as f
INNER JOIN film_category as fc ON f.film_id= fc.film_id 
INNER JOIN category as c ON fc.category_id= c.category_id 
HAVING(name="Family");

-- 7e. Display the most frequently rented movies in descending order.
SELECT f.title, count(f.title) as frequency
FROM film as f
INNER JOIN inventory as i ON f.film_id= i.film_id 
INNER JOIN rental as r ON i.inventory_id= r.inventory_id 
GROUP BY title
ORDER BY frequency DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, count(p.amount) as Total_amount
FROM store as s
INNER JOIN customer as c ON s.store_id= c.store_id 
INNER JOIN payment as p ON c.customer_id= p.customer_id 
GROUP BY store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, c.city, country.country 
FROM store AS s
JOIN address AS a ON s.address_id=a.address_id
JOIN city as c ON a.city_id=c.city_id
JOIN country AS country ON c.country_id=country.country_id;

-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT c.name, SUM(p.amount) AS gross_revenue
FROM category AS c
INNER JOIN film_category AS f ON c.category_id= f.category_id 
INNER JOIN inventory AS i ON f.film_id= i.film_id 
INNER JOIN rental AS r ON i.inventory_id= r.inventory_id 
INNER JOIN payment AS p ON p.rental_id= r.rental_id 
GROUP BY name
ORDER BY gross_revenue DESC
LIMIT 5;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
-- QUESTION: Why I can't drop it- I changed the order
DROP VIEW IF EXISTS top_genres_by_revenue;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_genres_by_revenue AS
SELECT c.name, SUM(p.amount) AS gross_revenue
FROM category AS c
INNER JOIN film_category AS f ON c.category_id= f.category_id 
INNER JOIN inventory AS i ON f.film_id= i.film_id 
INNER JOIN rental AS r ON i.inventory_id= r.inventory_id 
INNER JOIN payment AS p ON p.rental_id= r.rental_id 
GROUP BY name
ORDER BY gross_revenue DESC
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
SELECT* FROM top_genres_by_revenue


