# Tipos para strings
- Text
- Varchar()
- varchar
- char(n)

# Concatenacion

``` sql
SELECT 'Hola' || ' ' || 'Kevin';

SELECT CONCAT('Hola', ' ', 'Kevin');

SELECT nombre || ' - ' || email
FROM usuarios;
```

# Utils

```
-- Length
SELECT LENGTH(nombre);

-- Upper/Lower case
SELECT UPPER(nombre);
SELECT LOWER(nombre);

-- Capitalizar
SELECT INITCAP(nombre);

-- Substring
SELECT SUBSTRING(nombre FROM 1 FOR 3);
SELECT SUBSTRING(nombre, 1, 3);

-- Reemplazar
SELECT REPLACE(nombre, 'a', 'x');

-- Posición de texto
SELECT POSITION('a' IN nombre);

-- Trim (espacios)
SELECT TRIM(nombre);
SELECT LTRIM(nombre);
SELECT RTRIM(nombre);
SELECT TRIM(BOTH 'x' FROM 'xxxKevinxxx');

-- Split strings
SELECT STRING_TO_ARRAY('a,b,c', ',');
SELECT SPLIT_PART('a,b,c', ',', 2);

```

# Like
LIKE se usa para búsquedas por patrón dentro de strings.
% cualquier cantidad de caracteres
_ exactamente un caracter


## Empieza con 
``` sql
SELECT * 
FROM usuarios
WHERE nombre LIKE 'Kev%';
```

## Termina con
``` sql
WHERE email LIKE '%@gmail.com';
```

## Contiene

``` sql
WHERE nombre LIKE '%vin%';
```

## Un carácter específico

```
WHERE codigo LIKE 'A_1';
```