package com.learn.jdbctemplate;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.learn.jdbctemplate.Entity.Order;
import com.learn.jdbctemplate.Entity.Product;
import com.learn.jdbctemplate.Entity.Review;
import com.learn.jdbctemplate.Entity.User;

@Repository
public class Analytics {
     
    private final JdbcTemplate template;

    public Analytics(JdbcTemplate template) {
        this.template = template;
    }

    public List<User> findUserFromMexico() {
        String query = """
                SELECT * FROM users where country = ?
                """;

        List<User> users = template.query(
            query, 
            (rs, rowNumber) -> new User(
                rs.getLong("id"),
                rs.getString("name"),
                rs.getString("email"),
                rs.getString("country"),
                rs.getObject("created_at", LocalDateTime.class)
            ),
            "MX"
        );

        return users;
    }


    // Products category = electronics
    public List<Product> findProductByCategoryElectronics() {
        String query = """
                SELECT * FROM products where category = ?
                """;
        
        List<Product> products = template.query(
            query, 
            (rs, rowNumber) -> new Product(
                rs.getLong("id"),
                rs.getString("name"),
                rs.getString("category"),
                rs.getBigDecimal("price"),
                rs.getObject("created_at", LocalDateTime.class)
            ),
            "electronics"
        );

        return products;
    }

    // Obtener ordenes con estatus paid

    public List<Order> findOrdersByStatusPaid() {
        String query = """
                SELECT * FROM orders where status = ?
                """;
        
        List<Order> orders = template.query(
            query, 
            (rs, rowNumber) -> new Order(
                rs.getLong("id"), 
                rs.getLong("user_id"), 
                rs.getString("status"), 
                rs.getObject("created_at", LocalDateTime.class)
            ), 
        "paid");

        return orders;
    }

    public List<Review> findReviewsWithRating() {
        String query = """
                SELECT * FROM reviews WHERE rating >= 4;
                """;

        List<Review> reviews = template.query(query, (rs, rowNumber) -> new Review(
            rs.getLong("id"),
            rs.getLong("userId"),
            rs.getLong("product_id"),
            rs.getInt("rating"),
            rs.getString("comment"),
            rs.getObject("created_at", LocalDateTime.class)
        ));

        return reviews;
    } 

    record OrderWithUser(
        Long id,
        String username,
        String status,
        LocalDateTime createdAt
    ) {}

    public List<OrderWithUser> getOrdersWithUsername () {
        String query = """
                SELECT 
                    o.id,
                    o.status,
                    o.created_at,
                    u.name AS user_name
                FROM orders o join users u
                on u.id = o.user_id;
                """;
        
        return template.query(query, (rs, rowNumber) -> new OrderWithUser(
            rs.getLong("id"), 
            rs.getString("user_name"), 
            rs.getString("status"), 
            rs.getObject("created_at", LocalDateTime.class)
            )
        );
    }

    record OrderItemWithProductName (
        Long id,
        Long orderId,
        String productName,
        Integer quantity
    ) {}

    public List<OrderItemWithProductName> getOrderItemsWithProduct() {
        String query = """
                SELECT
                    o.id,
                    o.order_id,
                    p.name as product_name,
                    o.method,
                    o.quantity,
                FROM order_items o
                JOIN products p on o.product_id = p.id  
                """;
        
        return template.query(query, (rs, rowNumber) -> new OrderItemWithProductName(
            rs.getLong("id"), 
            rs.getLong("order_id"),
            rs.getString("product_name"),
            rs.getInt("quantity")
        ));
    }

    record SpentByUser (
        String userName,
        BigDecimal totalSpent
    ) {}

    public List<SpentByUser> totalSpentByUser() {
        String query = """
                SELECT u."name" as user_name, COALESCE(sum(p.amount), 0) as total_spent 
                FROM users u
                LEFT JOIN orders o on o.user_id = u.id
                LEFT JOIN payments p on p.order_id = o.id
                GROUP BY u.id,u."name";
                """;
        
        return template.query(query, (rs, rowNumber) -> new SpentByUser(
            rs.getString("user_name"),
            rs.getBigDecimal("total_spent")
        ));
    }



}
