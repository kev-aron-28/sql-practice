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