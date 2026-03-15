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


-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.