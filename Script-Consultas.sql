/* 2. Muestra los nombres de todas las películas con una clasificación por
edades de ‘R’*/
SELECT f.title
FROM film f 
WHERE f.rating = 'R';

-- 3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40
SELECT a.first_name 
FROM actor a  
WHERE a.actor_id BETWEEN 30 AND 40;

-- 4. Obtén las películas cuyo idioma coincide con el idioma original
SELECT *
FROM film f 
WHERE f.original_language_id = f.language_id;

-- 5. Ordena las películas por duración de forma ascendente.
SELECT *
FROM film f 
ORDER BY f.length ASC;

-- 6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.
SELECT CONCAT (a.first_name,' ', a.last_name) AS Nombre_actor
FROM actor a  
WHERE a.last_name ='ALLEN';

--7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento.
SELECT fc.category_id , COUNT(fc.category_id) AS "total_peliculas"
FROM film f 
INNER JOIN film_category fc  
    ON f.film_id = fc.film_id
        INNER JOIN category c 
            ON fc.category_id = c.category_id
GROUP BY fc.category_id
ORDER BY "total_peliculas" ASC;

-- 8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film.
SELECT f.title
FROM film f 
WHERE f.rating = 'PG-13' OR F.length > 180;

-- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
SELECT variance(f.replacement_cost )
FROM film f ;

-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
SELECT MAX(f.length ) AS duracion_maxima, MIN(f.length )AS duracion_minima
FROM film f ;

-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
SELECT r.rental_id, r.rental_date, p.amount
FROM rental r
JOIN payment p 
ON r.rental_id = p.rental_id
ORDER BY r.rental_date DESC
OFFSET 2
LIMIT 1;

-- 12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC-17’ ni ‘G’ en cuanto a su clasificación.
SELECT f.title
FROM film f 
WHERE f.rating NOT IN ('NC-17' ,'G');

-- 13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
SELECT AVG(f.length) AS promedio_duracion, f.rating AS clasificacion
FROM film f 
GROUP BY f.rating;

-- 14. Encuentra el título de todas las películas que tengan una duración mayora 180 minutos.
SELECT f.title AS Titulo_pelicula
FROM film f 
WHERE f.length >180;

-- 15. ¿Cuánto dinero ha generado en total la empresa?
SELECT SUM(p.amount ) AS Total_generado
FROM payment p;
-- 16. Muestra los 10 clientes con mayor valor de id.
SELECT c.customer_id
FROM customer c
ORDER BY c.customer_id DESC
LIMIT 10;
-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.
SELECT CONCAT(a.first_name,' ', a.last_name ) AS Actor
FROM actor a
WHERE a.actor_id  IN (
    SELECT fa.actor_id 
    FROM film_actor fa 
    INNER JOIN film f 
        ON fa.film_id =f.film_id
    WHERE f.title ='EGG IGBY' 
);

-- 18. Selecciona todos los nombres de las películas únicos.
SELECT f.title
FROM film f;

-- 19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”.
SELECT f.title
FROM film f 
WHERE F.film_id  IN (
    SELECT fc.film_id
    FROM film_category fc  
    INNER JOIN category c 
        ON FC.category_id =C.category_id
    WHERE c."name" ='Comedy'
)
AND F.length >180
;

/* 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de 
la categoría junto con el promedio de duración.*/
SELECT c."name" , AVG(F.length)
FROM category c 
INNER JOIN film_category fc 
ON C.category_id =fc.category_id
    INNER JOIN film f 
    ON fc.film_id =f.film_id
GROUP BY c.category_id 
HAVING AVG(f.length)>110;

-- 21. ¿Cuál es la media de duración del alquiler de las películas?
SELECT AVG(f.rental_duration)
FROM film f;
-- 22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
SELECT CONCAT(a.first_name,' ', a.last_name ) AS Nombre_Actor
FROM actor a;

-- 23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
SELECT count(R.rental_id),R.rental_date
FROM rental r 
GROUP BY r.rental_date
ORDER BY count(R.rental_id) DESC;

-- 24. Encuentra las películas con una duración superior al promedio.
SELECT f.title
FROM film f
WHERE f.length > (SELECT AVG(f.length)
                    FROM film f);

-- 25. Averigua el número de alquileres registrados por mes.
SELECT count(r.rental_id) AS total_alquileres, EXTRACT(MONTH FROM rental_date) AS Mes
FROM rental r
GROUP BY EXTRACT(MONTH FROM rental_date);

-- 26. Encuentra el promedio, la desviación estándar y varianza del total pagado.
SELECT AVG(p.amount ) AS promedio, stddev(p.amount) AS desviacion_estandar, variance(p.amount)
FROM payment p;
-- 27. ¿Qué películas se alquilan por encima del precio medio?
SELECT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON p.rental_id =r.rental_id
WHERE p.amount > (SELECT AVG(P.amount)
                    FROM payment p)
;
-- 28. Muestra el id de los actores que hayan participado en más de 40 películas.
SELECT fa.actor_id
FROM film_actor fa
GROUP BY fa.actor_id
HAVING COUNT(fa.film_id)>40;


-- 29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
SELECT COUNT(i.inventory_id), i.film_id
FROM inventory i 
WHERE EXISTS(
SELECT 1
FROM film
WHERE i.film_id =film.film_id )
GROUP BY i.film_id;
-- 30. Obtener los actores y el número de películas en las que ha actuado.
SELECT fa.actor_id,COUNT(fa.film_id) AS total_peliculas, 
    (SELECT CONCAT(a.first_name,' ', a.last_name )
        FROM actor a
        WHERE a.actor_id=fa.actor_id) AS nombre_actor
FROM film_actor fa
GROUP BY fa.actor_id;

-- 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
SELECT f.title AS Pelicula, fa.actor_id AS Actor
FROM film f 
LEFT JOIN film_actor fa 
ON fa.film_id =f.film_id;
/* 32. Obtener todos los actores y mostrar las películas en las que han 
actuado, incluso si algunos actores no han actuado en ninguna película.*/
SELECT CONCAT(a.first_name,' ', a.last_name ) AS Actor, f.title AS Pelicula
FROM actor a
LEFT JOIN film_actor fa
ON a.actor_id =fa.actor_id 
    LEFT JOIN film f 
        ON fa.film_id =f.film_id;

-- 33. Obtener todas las películas que tenemos y todos los registros de alquiler.
SELECT f.film_id AS pelicula
FROM film f;

SELECT r.rental_id AS registro_alquiler
FROM rental r ;
--34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
SELECT p.customer_id , SUM(p.amount) AS dinero_gastado
FROM payment p
GROUP BY p.customer_id
ORDER BY SUM(p.amount) DESC
LIMIT 5;
--35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
SELECT CONCAT(a.first_name,' ', a.last_name ) AS Actor
FROM actor a
WHERE a.first_name ='JOHNNY';
--36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.
SELECT a.first_name AS Nombre, a.last_name AS Apellido
FROM actor a;

-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
SELECT MAX(a.actor_id), MIN(a.actor_id)
FROM actor a;
-- 38. Cuenta cuántos actores hay en la tabla “actor”.
SELECT COUNT(*)
FROM actor a;
-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
SELECT a.first_name AS Nombre, a.last_name AS Apellido
FROM actor a
ORDER BY a.last_name ASC;
-- 40. Selecciona las primeras 5 películas de la tabla “film”.
SELECT f.title AS Pelicula
FROM film f 
LIMIT 5;
-- 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
SELECT a.first_name AS Nombre, COUNT(a.actor_id)
FROM actor a
GROUP BY a.first_name
ORDER BY COUNT(a.actor_id) DESC;

-- Nombres mas repetidos: Kenneth, Penelope, Julia

-- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
SELECT r.rental_id AS ID_Alquiler, CONCAT(c.first_name,' ', c.last_name ) AS Cliente
FROM rental r 
INNER JOIN customer c 
ON r.customer_id =c.customer_id;


-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
SELECT CONCAT(c.first_name,' ', c.last_name ) AS Cliente, r.rental_id AS Id_alquiler
FROM customer c
LEFT JOIN rental r 
ON r.customer_id =c.customer_id;
-- 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.
SELECT *
FROM film f 
CROSS JOIN category c;

/* Respuesta: esta consulta realiza combinaciones de cada pelicula con todas las categorias existentes.
 No tiene valor ya que cada pelicula solo va a pertenecer a una categoria por lo que obtener combinaciones pelicula-categoria
 no aporta informacion relevante */
 
-- 45. Encuentra los actores que han participado en películas de la categoría 'Action'.
SELECT CONCAT(a.first_name,' ', a.last_name ) AS Actor
FROM actor a 
INNER JOIN film_actor fa 
ON fa.actor_id =a.actor_id
WHERE fa.film_id IN
    (SELECT f.film_id 
    FROM film f 
    INNER JOIN film_category fc 
    ON f.film_id =fc.film_id
    INNER JOIN category c 
    ON fc.category_id =c.category_id
    WHERE c."name" ='Action');
-- 46. Encuentra todos los actores que no han participado en películas.
SELECT CONCAT(a.first_name,' ', a.last_name ) AS Actor
FROM actor a 
WHERE NOT EXISTS(
SELECT 1
FROM film_actor fa
WHERE a.actor_id =fa.actor_id
);
--  47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
SELECT CONCAT(a.first_name,' ', a.last_name ) AS Actor, COUNT(fa.film_id) AS total_peliculas
FROM actor a 
INNER JOIN film_actor fa 
ON a.actor_id =fa.actor_id
GROUP BY a.actor_id;

-- 48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.
CREATE VIEW actor_num_peliculas AS
SELECT CONCAT(a.first_name,' ', a.last_name ) AS Actor, COUNT(fa.film_id) AS total_peliculas
FROM actor a 
INNER JOIN film_actor fa 
ON a.actor_id =fa.actor_id
GROUP BY a.actor_id;

-- 49. Calcula el número total de alquileres realizados por cada cliente.
SELECT CONCAT(c.first_name,' ', c.last_name ) AS Cliente, COUNT(R.rental_id) AS total_alquileres
FROM customer c
INNER JOIN rental r 
ON r.customer_id =c.customer_id
GROUP BY c.customer_id;
-- 50. Calcula la duración total de las películas en la categoría 'Action'.
SELECT f.title, f.length AS Duracion
FROM film f 
INNER JOIN film_category fc 
ON f.film_id =fc.film_id
    INNER JOIN category c 
    ON fc.category_id =c.category_id
WHERE c."name" ='Action';
--51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.
CREATE TEMPORARY TABLE cliente_rentas_temporal AS(
SELECT CONCAT(c.first_name,' ', c.last_name ) AS Cliente, COUNT(R.rental_id) AS total_alquileres
FROM customer c
INNER JOIN rental r 
ON r.customer_id =c.customer_id
GROUP BY c.customer_id
)
/*52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las
películas que han sido alquiladas al menos 10 veces.*/
CREATE TEMPORARY TABLE peliculas_alquiladas AS(
SELECT r.rental_id
FROM inventory i
INNER JOIN rental r 
ON i.inventory_id=r.inventory_id
INNER JOIN film f 
ON F.film_id =i.film_id
GROUP BY r.rental_id 
HAVING COUNT(f.film_id)>10
)

/*53. Encuentra el título de las películas que han sido alquiladas por el cliente
con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.*/
SELECT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN customer c ON r.customer_id = c.customer_id
WHERE c.first_name = 'Tammy' 
AND c.last_name = 'Sanders'
AND r.return_date IS NULL
ORDER BY f.title DESC;


/*54. Encuentra los nombres de los actores que han actuado en al menos una
película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados
alfabéticamente por apellido.*/
SELECT CONCAT(a.first_name,' ', a.last_name ) AS Actor
FROM actor a 
INNER JOIN film_actor fa 
ON fa.actor_id =a.actor_id
WHERE fa.film_id IN
    (SELECT f.film_id 
    FROM film f 
    INNER JOIN film_category fc 
    ON f.film_id =fc.film_id
    INNER JOIN category c 
    ON fc.category_id =c.category_id
    WHERE c."name" ='Sci-Fi')
GROUP BY a.actor_id 
ORDER BY a.last_name ASC;

/* 55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus
Cheaper’ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.*/
SELECT CONCAT(a.first_name,' ', a.last_name ) AS Actor
FROM actor a 
INNER JOIN film_actor fa 
ON fa.actor_id =a.actor_id
WHERE fa.film_id IN(
    SELECT f.film_id
    FROM film f
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    WHERE R.rental_date > (SELECT MIN(r.rental_date)
                            FROM rental r
                            JOIN inventory i ON r.inventory_id =i.inventory_id
                            JOIN film f ON f.film_id = i.film_id
                            WHERE f.title ='SPARTACUS CHEAPER')
    )
GROUP BY a.actor_id 
ORDER BY a.last_name ASC;

--56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.
SELECT CONCAT(a.first_name,' ', a.last_name ) AS Actor
FROM actor a 
INNER JOIN film_actor fa 
ON fa.actor_id =a.actor_id
WHERE fa.film_id NOT IN
    (SELECT f.film_id 
    FROM film f 
    INNER JOIN film_category fc 
    ON f.film_id =fc.film_id
    INNER JOIN category c 
    ON fc.category_id =c.category_id
    WHERE c."name" ='Music')
GROUP BY a.actor_id ;

--57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
SELECT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE EXTRACT(DAY FROM r.return_date - r.rental_date)>8
;
--58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.
SELECT f.title 
FROM film f 
INNER JOIN film_category fc 
ON f.film_id =fc.film_id
    INNER JOIN category c 
    ON fc.category_id =c.category_id
WHERE c."name" ='Animation';
/* 59. Encuentra los nombres de las películas que tienen la misma duración
que la película con el título ‘Dancing Fever’. Ordena los resultados
alfabéticamente por título de película.*/
SELECT f.title
FROM film f
WHERE f.length IN(
   SELECT f.length 
   FROM film f 
   WHERE f.title = 'DANCING FEVER')
ORDER BY f.title ASC
;
--60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
SELECT CONCAT(c.first_name,' ', c.last_name ) AS Cliente
FROM customer c
INNER JOIN rental r ON r.customer_id =c.customer_id
INNER JOIN inventory i ON i.inventory_id =r.inventory_id
GROUP BY c.customer_id  
HAVING COUNT(i.film_id)>7
ORDER BY c.last_name;

--61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
SELECT COUNT(i.film_id) AS Peliculas_alquiladas, c."name" AS Categoria
FROM inventory i 
INNER JOIN film f ON f.film_id =i.film_id
INNER JOIN film_category fc ON fc.film_id =f.film_id
INNER JOIN category c ON fc.category_id =c.category_id
GROUP BY c.category_id ;

--62. Encuentra el número de películas por categoría estrenadas en 2006.
SELECT COUNT(f.film_id) AS total_peliculas_2006, c."name" AS categoria
FROM film f 
INNER JOIN film_category fc
ON f.film_id =fc.film_id
    INNER JOIN category c 
    ON fc.category_id =c.category_id
WHERE f.release_year = 2006
GROUP BY c.name;
--63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
SELECT *
FROM staff s 
CROSS JOIN store s2 ;
/* 64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, 
su nombre y apellido junto con la cantidad de películas alquiladas.*/
SELECT c.first_name AS Nombre, c.last_name AS Apellido, c.customer_id AS ID_Cliente, COUNT(I.film_id) AS Peliculas_alquiladas
FROM customer c 
INNER JOIN rental r ON R.customer_id =c.customer_id
INNER JOIN inventory i ON I.inventory_id =R.inventory_id
GROUP BY c.customer_id;