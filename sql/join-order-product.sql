SELECT
    o.order_id,
    o.user_id,
    o.order_number,
    o.order_dow,
    o.order_hour_of_day,
    o.days_since_prior_order,
    op.product_id,
    op.add_to_cart_order,
    op.reordered
FROM orders o
JOIN order_products_prior op
    ON o.order_id = op.order_id
WHERE o.eval_set = 'prior'