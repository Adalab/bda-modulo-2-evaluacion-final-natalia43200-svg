USE sakila;

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
SELECT DISTINCT title
	FROM film;


-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
SELECT title, rating -- me interesa ver el rating para la comprobación
	FROM film
	WHERE rating = 'PG-13';


-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT title, description
	FROM film
	WHERE description LIKE '%amazing%'; -- pongo el % donde le indico que debe contener la palabra
-- LIKE nos permite buscar patrones dentro de un texto



-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
SELECT title, length -- me interesa ver el length para la comprobación
	FROM film
	WHERE length > 120;

-- 5. Recupera los nombres de todos los actores.
SELECT first_name
	FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
SELECT first_name, last_name
	FROM actor
	WHERE last_name LIKE '%Gibson%';

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
SELECT first_name, actor_id
	FROM actor
	WHERE actor_id BETWEEN 10 AND 20;


-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
SELECT title, rating -- me interesa ver el rating para la comprobación
	FROM film
	WHERE rating NOT IN ('R','PG-13'); -- el NOT IN necesita una lista entre parentesis


-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
SELECT rating, COUNT(*) AS total_peliculas -- queremos contar filas de la tabla 
	FROM film
GROUP BY rating;
-- Siempre que usamos COUNT() junto con una columna necesitamos GROUP BY


-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

-- vamos a resolverlo PASO A PASO
-- 1. Voy a ver la info de clientes:
SELECT *
	FROM customer;
-- 2. Voy a ver la info de alquileres
SELECT *
	FROM rental;
-- Me doy cuenta de que en ambas hay/coinciden customer_id y lo voy a unir con INNER JOIN 

SELECT c.customer_id, c.first_name, c.last_name, COUNT(*) AS peliculas_alquiladas
	FROM customer AS c
INNER JOIN rental AS r
	ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name; -- me agrupa las filas para hacer calculos por grupo


-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
-- las tablas que voy a necesitar serán:
-- category, film_category, film, inventory, rental --> uno las tablas con INNER JOIN 
-- descubrir para categoria cuantos alquileres

SELECT c.name, COUNT(*) AS peliculas_alquiladas
	FROM category AS c
INNER JOIN film_category AS fc
    ON c.category_id = fc.category_id
INNER JOIN film AS f
    ON fc.film_id = f.film_id
INNER JOIN inventory AS i
    ON f.film_id = i.film_id
INNER JOIN rental AS r
    ON i.inventory_id = r.inventory_id
GROUP BY c.name;


-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film 
-- y muestra la clasificación junto con el promedio de duración.
-- para el promedio se usa AVG


-- 1. Ver datos
SELECT rating, length
	FROM film;

SELECT rating, AVG(length) AS promedio_duracion
	FROM film
GROUP BY rating;


-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

-- Actor y film no están conectados directamente, la tabla puente es film_actor
-- Uno las tres tablas para obtener los actores de esa película.


SELECT a.first_name, a.last_name, f.title
	FROM actor AS a
INNER JOIN film_actor AS af
	ON a.actor_id = af.actor_id
INNER JOIN film AS f
	ON af.film_id = f.film_id
WHERE f.title = 'Indian Love';

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
SELECT title, description
	FROM film
    WHERE description LIKE '%dog%' OR -- con el OR le estoy diciendo que se cumpla o una o la otra condicion
			description LIKE '%cat%'; -- si puesiese AND deberia tener ambas condiciones


-- 15. Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor.
-- lo que me esta diciendo es que busque actores pero que no tienen relacion con ninguna pelicula

-- los actores que SI aparecen(esta será la subconsulta que meteré luego despues del NOT IN)
SELECT actor_id
FROM film_actor;

SELECT first_name, last_name
FROM actor
WHERE actor_id NOT IN (
    SELECT actor_id
    FROM film_actor
); -- al ejectutarlo me da que todos los actores de la tabla actor aparecen al menos en una pelicula



-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
-- al observar la tabla film el release_year de todos es igual a 2006
SELECT title, release_year
	FROM film
    WHERE release_year BETWEEN 2005 AND 2010;

-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".
-- primero hago una subconsulta para saber que category_id tiene Family
SELECT category_id
	FROM category
    WHERE name = 'Family'; -- esto me da 8
    
    -- ahora voy a buscar las pelis de esa categoria:
SELECT film_id
	FROM film_category
	WHERE category_id = 8;


SELECT title
FROM film
WHERE film_id IN(
    SELECT film_id
    FROM film_category
    WHERE category_id = (
        SELECT category_id
        FROM category
        WHERE name = 'Family')
);


-- Para una mejor comprobación, hago uso de INNER JOIN para poder introducirlos en el SELECT

SELECT f.title, c.name, c.category_id
	FROM film AS f
INNER JOIN film_category AS fc
    ON f.film_id = fc.film_id
INNER JOIN category AS c
    ON fc.category_id = c.category_id
WHERE c.name = 'Family';

/* CAMINOS DE SAKILA
actor --> film_actor --> film
film --> film_category --> category
film --> inventory --> rental
*/

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT a.actor_id, a.first_name, a.last_name, COUNT(*) AS total_peliculas
	FROM actor AS a
INNER JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(*) > 10;


-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
-- dos horas equivalen a 120 minutos

SELECT title, rating, length
	FROM film
WHERE rating = 'R'
AND length > 120;
-- Con AND le estoy diciendo que cumpla ambas condiciones

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos 
-- y muestra el nombre de la categoría junto con el promedio de duración.
-- hago uso del HAVING porque primero hay que calcular el promedio por categoría y después filtrar esos grupos
SELECT c.name, AVG(f.length) AS duracion_promedio
	FROM category AS c
INNER JOIN film_category AS fc
    ON c.category_id = fc.category_id
INNER JOIN film AS f
    ON fc.film_id = f.film_id
GROUP BY c.name
HAVING AVG(f.length) > 120; -- para filtrar grupos y WHERE es para filtrar filas


-- 21. Encuentra los actores que han actuado en al menos 5 películas y 
-- muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

SELECT a.first_name, a.last_name, COUNT(*) AS total_peliculas
	FROM actor AS a
INNER JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(*) >= 5;


-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. 
-- Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días 

-- la subconsulta:
SELECT rental_id
    FROM rental
    WHERE return_date - rental_date > 5




SELECT f.title, r.rental_id, r.rental_date, r.return_date
	FROM film AS f
INNER JOIN inventory AS i
    ON f.film_id = i.film_id
INNER JOIN rental AS r
    ON i.inventory_id = r.inventory_id
WHERE r.rental_id IN (
    SELECT rental_id
    FROM rental
    WHERE return_date - rental_date > 5
);

-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría
-- "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la
-- categoría "Horror" y luego exclúyelos de la lista de actores.

-- primera subconsulta, actores que si han actuado en horror
SELECT a.actor_id, a.first_name, a.last_name
	FROM actor AS a
INNER JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
INNER JOIN film_category AS fc
    ON fa.film_id = fc.film_id
INNER JOIN category AS c
    ON fc.category_id = c.category_id
WHERE c.name = 'Horror';


SELECT actor_id, first_name, last_name
	FROM actor
WHERE actor_id NOT IN (
    SELECT a.actor_id
    FROM actor AS a
    INNER JOIN film_actor AS fa
        ON a.actor_id = fa.actor_id
    INNER JOIN film_category AS fc
        ON fa.film_id = fc.film_id
    INNER JOIN category AS c
        ON fc.category_id = c.category_id
    WHERE c.name = 'Horror'
);

-- 24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.

SELECT f.title, c.name, f.length
	FROM film AS f
INNER JOIN film_category AS fc
    ON f.film_id = fc.film_id
INNER JOIN category AS c
    ON fc.category_id = c.category_id
WHERE c.name = 'Comedy'
AND f.length > 180;

