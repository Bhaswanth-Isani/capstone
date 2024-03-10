CREATE TABLE product_logs (
    shelf_id String,
    product_id String,
    quantity UInt32,
    created_at DateTime DEFAULT now(),
) ENGINE = MergeTree() PRIMARY KEY (shelf_id, product_id, created_at)