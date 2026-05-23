What is ORM?
ORM = Object Relational Mapping

It maps:

Java objects ↔ database tables
object fields ↔ columns
object relationships ↔ foreign keys

What is JPA?
Java persistence API
It is NOT an implementation.

It is a specification (interfaces + rules).

JPA = contract
Hibernate = implementation

What is Hibernate?
Hibernate ORM is the most popular JPA implementation.

Hibernate actually:
- generates SQL
- manages entities
- tracks changes
- handles caching
- executes queries

What is Spring Data JPA?
Spring Data JPA sits on top of JPA/Hibernate.

# Persistence context
A container that manages entities in memory. Managed entities are tracked automatically.

``` java
@Transactional
public void updateUser() {

    User user = repository.findById(1L).get();

    user.setName("Kevin");
}
```

You never called save().
This is called dirty checking, JPA compares original state and current state. Then generates SQL automatically.


# Managed entities
When an entity is loaded inside a transaction:

``` java
User user = em.find(User.class, 1L);
```

It becomes managed.

JPA now watches it.

Changes become automatic SQL updates.

## Entity Lifecycle

Critical topic

1. Transient
Object exists only in Java memory

2. Persistent 
Not entity is managed and tracked by context

3. Detached
Entity exists but is no longer managed.

4. Removed
Will be deleted on flush/commit

# Entity mapping
An entity is a Java class mapped to a database table


``` java
@Entity
public class User {

}
```

## @Table
Use table to customize table mapping

``` java
@Entity
@Table(name = "users")
public class User {

}
```

## Primary keys

Every entity must have a primary key

``` java
@Id
private Long id;
```

``` java
@Entity
@Table(name = "users")
public class User {

    @Id
    private Long id;

    private String name;
}
```

## GeneratedValue
Usually IDs are auto-generated

``` java
@Id
@GeneratedValue
private Long id;
```

### Generation strategies

1. Identity

``` java
@GeneratedValue(strategy = GenerationType.IDENTITY)
```
Database generates ID.

Example:
PostgreSQL SERIAL
MySQL AUTO_INCREMENT

Pros:
- Simple
- Common

Cons: 
- Disables JDBC batch inserts
- Insert must happen immediately

2. SEQUENCE

```
@GeneratedValue(strategy = GenerationType.SEQUENCE)
```

Uses database sequence
Hibernate can prefetch IDs. and this enables batching and performance

3. AUTO

```
@GeneratedValue(strategy = GenerationType.AUTO)
```

Hibernate chooses strategy automatically.

Not always predictable.

4. UUID
Modern systems often use UUIDs

``` 
@Id
@GeneratedValue(strategy = GenerationType.UUID)
private UUID id;
```

## @Columm
Customize column mapping

```
@Column(name = "full_name")
private String name;
```

### Common options
- nullable
- unique
- length
- precision / scale

# Types
| Java Type     | SQL Type  |
| ------------- | --------- |
| String        | VARCHAR   |
| int           | INTEGER   |
| long          | BIGINT    |
| BigDecimal    | DECIMAL   |
| LocalDate     | DATE      |
| LocalDateTime | TIMESTAMP |
| Boolean       | BOOLEAN   |
| UUID          | UUID      |


# Enum Mapping

- Ordinal
``` java
public enum Status {
    ACTIVE,
    INACTIVE
}

@Enumerated(EnumType.ORDINAL)

ACTIVE = 0
INACTIVE = 1
```

Changing enum order breaks data.

- String

``` java
@Enumerated(EnumType.STRING)
private Status status;

ACTIVE
INACTIVE
```

# SQL schema generation
Hibernate can generate schema automatically

``` 
spring.jpa.hibernate.ddl-auto=update
```

## SQL Logging
```
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
```

# Relationship types

| Relationship | Annotation    |
| ------------ | ------------- |
| One-to-One   | `@OneToOne`   |
| One-to-Many  | `@OneToMany`  |
| Many-to-One  | `@ManyToOne`  |
| Many-to-Many | `@ManyToMany` |


## Example ManyToOne

``` java
@Entity
public class User {

    @Id
    private Long id;

    private String name;
}

@Entity
@Table(name = "orders")
public class Order {

    @Id
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    private BigDecimal total;
}
```

JoinColumn defines the foreing key column

## Example OneToMany
``` java
@Entity
public class User {

    @Id
    private Long id;

    @OneToMany(mappedBy = "user")
    private List<Order> orders = new ArrayList<>();
}
```

mappedBy: The relationship is owned by the user field inside order

## Owning side
The side that contains:

- foreign key
- @JoinColumn

## Example OneToOne

```
profiles
--------
id
user_id UNIQUE
bio

@OneToOne
@JoinColumn(name = "user_id")
private User user;


--

@OneToOne(mappedBy = "user")
private Profile profile;
```

## Example Many to many

```
student_courses
----------------
student_id
course_id
---

@ManyToMany
@JoinTable(
    name = "student_courses",
    joinColumns = @JoinColumn(name = "student_id"),
    inverseJoinColumns = @JoinColumn(name = "course_id")
)
private List<Course> courses;

```

# Cascade types

- PERSIST
- MERGE
- REMOVE
- ALL

# Fetch types
- LAZY

``` java
@ManyToOne(fetch = FetchType.LAZY)
```

- EAGER
