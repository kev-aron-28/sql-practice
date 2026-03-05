# JDBC template
JDBCTemplate belongs to Spring Framework

```
org.springframework.jdbc.core.JdbcTemplate

<dependency>
	<groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jdbc</artifactId>
</dependency>
```
It is a wrapper around JDBC that handles boilerplate code and exception translation

it removes:
- Try/catch/finally
- closing resources
- connection handling
- exception translation

But still uses JDBC underneath

# Configuration

At runtime the flow looks like this:
Repository -> JdbcTemplate -> DataSource -> Connecition Pool (Hakari) -> database

Jdbctempalte does not manage the connections itself, it asks the data source for one

## What is datasource?
javax.sql.DataSource

it is a factory of Connections
So instead of DriverManager.getConnection() you do datasource.getConnection() this supports:
- Connection pooling
- JNDI lookup
- External configuration
- Transaction synchronization

## Types of DataSource
- DriverManagerDataSource
- HikariDataSource (prodution standard)


## Connection pooling
When you dont have pooling:
- every request opens a new DB connection
- very slow
- db gets overloaded

with pooling:
- connections are reused
- huge performance gain

and HakariCP maintains: 
- minimum idle connections
- maximum pool size
- timeout policies
- leak detection

## Properties
spring.datasource.hikari.maximum-pool-size=10
spring.datasource.hikari.minimum-idle=5
spring.datasource.hikari.connection-timeout=30000
spring.datasource.hikari.idle-timeout=600000
spring.datasource.hikari.max-lifetime=1800000

- maximumPoolSize: Maximum simultaneous connections
- connectionTimeout: How long a thread waits before failing
- maxLifetime: prevents stale connections

# Creating JDbcTemplate bean manual

``` java
@Configuration
public class PersistenceConfig {
    @Bean
    public DataSource dataSource() {
        HikariDataSource ds = new HikariDataSource();
        ds.setJdbcUrl("jdbc:postgresql://localhost:5432/test");
        ds.setUsername("user");
        ds.setPassword("pass");
        return ds;
    }

    @Bean
    public JdbcTemplate jdbcTemplate(DataSource ds) {
        return new JdbcTemplate(ds);
    }
}
```

# TransactionManager configuration

JdbcTemplate does not manage transaction alone you need:

``` java
    @Bean
    public PlatformTransactionManager transactionManager(DataSource ds) {
        return new DataSourceTransactionManager(ds);
    }
```
with this you enable @Transactional:
- Spring creates a proxy
- Proxy intercepts method
- Opens connection
- sets autocomit(false)
- commits or rollbacks

# Core operations
Everythign revolves around how PreparedStatement works underneath JdbcTemplate

## Parameter binding
When you write:

``` java
jdbcTemplate.update(
    "INSERT INTO users(name, email) VALUES (?, ?)",
    name,
    email
);
```
Internally:
1. JDBC template gets a connection
2. Calls prepareStatement
3. Binds parameters with setX
4. Executes


## SQL types
- VARCHAR
- INTEGER
- BIGINT
- TIMESTAMP
- BOOLEAN
- NUMERIC

and JdbcMust map between them

- Automatic type detection: The driver determines SQL type automatically
- Explicit SQL types

``` java
 template.update(query,
    new Object[] { name, null },
    new int[] { Types.VARCHAR, Types.VARCHAR }
);
```

## Core operations
- update(): Insert, update, delete
- query(): Multiple rows
- queryForObject(): Single row/ single column
- queryForList(), queryForMap()
- batchUpdate()
- execute()

### UPDATE()
This is used for data modification like update, insert, delete
``` java
jdbcTemplate.update(
    "UPDATE users SET name = ? WHERE id = ?",
    "Kevin",
    1L
);
```

``` java
jdbcTemplate.update(
    "INSERT INTO users(name, age) VALUES (?, ?)",
    new Object[]{"Kevin", 21},
    new int[]{Types.VARCHAR, Types.INTEGER}
);
```

### QUERY()
Returns a List<T> and needs a RowMapper

``` java
List<User> users = jdbcTemplate.query(
    "SELECT * FROM users",
    new UserRowMapper()
);

List<User> users = jdbcTemplate.query(
    "SELECT * FROM users",
    (rs, rowNum) -> new User(
        rs.getLong("id"),
        rs.getString("name"),
        rs.getString("email")
    )
);
```

### QUERYFOROBJECT() 
Used when expeting one row
This throws an exception if 0 rows
Throws an exception if > 1 row
``` java
User user = jdbcTemplate.queryForObject(
    "SELECT * FROM users WHERE id = ?",
    new UserRowMapper(),
    1L
);

Integer count = jdbcTemplate.queryForObject(
    "SELECT COUNT(*) FROM users",
    Integer.class
);
```

### QUERYFORLIST() and QUERYFORMAP()
- queryForList()
Each row is a Map

``` java
List<Map<String, Object>> results =
    jdbcTemplate.queryForList("SELECT * FROM users");
```

- queryForMap()
Returns one row as a Map
but throws exception if more than one row
``` java
Map<String, Object> user =
    jdbcTemplate.queryForMap(
        "SELECT * FROM users WHERE id = ?",
        1L
    );
```

- batchUpdate() 
Used when inserting/updating many rows

``` java
jdbcTemplate.batchUpdate(
    "INSERT INTO users(name) VALUES (?)",
    List.of(
        new Object[]{"Kevin"},
        new Object[]{"Ana"}
    )
);

jdbcTemplate.batchUpdate(
    "INSERT INTO users(name, age) VALUES (?, ?)",
    users,
    users.size(),
    (ps, user) -> {
        ps.setString(1, user.getName());
        ps.setInt(2, user.getAge());
    }
);
```

### EXECUTE()
Most flexibe method

``` java
jdbcTemplate.execute(
    "CREATE TABLE test(id INT)"
);
```

# RowMapper
## What is a RowMapper really?
RowMapper is an interface

``` java
public interface RowMapper<T> {
    T mapRow(ResultSet rs, int rowNum) throws SQLException;
}
```

A function that converts one row of a result set into a java object


How ResultSet works?
This comes from JDBC
Result set:
- is not thread safe
- not cached
- backed by database cursor

## Column mapping strategies
- By column index
- By column name

``` java
rs.getLong(1);
rs.getLong("id");
```

## Alias mapping
select first_name as firstName from users;
``` java
rs.getString("firstName");
```

## Null handling (critical)

``` java
long id = rs.getLong("id");
if (rs.wasNull()) {
    // handle null
}
```

``` java
Long id = rs.getObject("id", Long.class);
```

# Type conversion
| SQL Type  | Java Type     |
| --------- | ------------- |
| BIGINT    | Long          |
| INTEGER   | Integer       |
| VARCHAR   | String        |
| BOOLEAN   | Boolean       |
| DATE      | LocalDate     |
| TIMESTAMP | LocalDateTime |
| NUMERIC   | BigDecimal    |

``` java
public class UserRowMapper implements RowMapper<User> {

    @Override
    public User mapRow(ResultSet rs, int rowNum) throws SQLException {

        return new User(
            rs.getObject("id", Long.class),
            rs.getString("name"),
            rs.getString("email"),
            rs.getObject("age", Integer.class),
            rs.getObject("created_at", LocalDateTime.class)
        );
    }
}
```