-- Q1: Which store generates the most revenue?
SELECT 
    store_name, 
    city, 
    state,
    total_revenue,
    total_orders,
    ROUND(total_revenue / total_orders, 2) AS avg_order_value
FROM revenue_by_store
ORDER BY total_revenue DESC;

-- Q2: Best-selling category by units sold?
SELECT 
    category_name,
    total_units_sold,
    total_revenue,
    ROUND(total_revenue / total_units_sold, 2) AS avg_price_per_unit
FROM revenue_by_category
ORDER BY total_units_sold DESC;

-- Q3: Top 5 customers by lifetime value?
SELECT 
    customer_name, 
    customer_city, 
    customer_state,
    lifetime_value, 
    total_orders, 
    last_order_date
FROM top_customers
ORDER BY lifetime_value DESC
LIMIT 5;

-- Q4: Which year had the highest revenue?
SELECT 
    year,
    ROUND(SUM(total_revenue), 2) AS yearly_revenue,
    SUM(total_orders) AS yearly_orders,
    SUM(total_units_sold) AS yearly_units
FROM monthly_revenue
GROUP BY year
ORDER BY yearly_revenue DESC;

-- Q5: Which staff member handled the most orders?
SELECT 
    staff_name, 
    store_name,
    completed_orders,
    total_revenue_generated,
    unique_customers_served
FROM staff_performance
ORDER BY completed_orders DESC
LIMIT 5;

-- Q6: Stores with critical stock levels (quantity = 0)?
SELECT 
    store_name,
    COUNT(*) AS out_of_stock_products
FROM low_stock_alert
WHERE quantity = 0
GROUP BY store_name
ORDER BY out_of_stock_products DESC;
