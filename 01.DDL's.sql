-- Campaigns table

CREATE TABLE marketing_and_ecommerce_analysis.campaigns (
  campaign_id INT PRIMARY KEY,
  channel VARCHAR(50) DEFAULT NULL,
  objective VARCHAR(50) DEFAULT NULL,
  start_date  DATE DEFAULT NULL,
  end_date DATE DEFAULT NULL,
  target_segment VARCHAR(50) DEFAULT NULL,
  expected_uplift DECIMAL(10, 3) DEFAULT NULL
  );


-- Customers table

CREATE TABLE marketing_and_ecommerce_analysis.customers (
  customer_id INT PRIMARY KEY,
  signup_date DATE DEFAULT NULL,
  country VARCHAR(20) DEFAULT NULL,
  age INT DEFAULT NULL,
  gender VARCHAR(10) DEFAULT NULL,
  loyalty_tier VARCHAR(20) DEFAULT NULL,
  acquisition_channel VARCHAR(20) DEFAULT NULL
);


-- Events table


CREATE TABLE marketing_and_ecommerce_analysis.events (
  event_id INT NOT NULL,
  timestamp TIMESTAMP NOT NULL,
  customer_id INT NOT NULL,
  session_id INT DEFAULT NULL,
  event_type VARCHAR(15) DEFAULT NULL,
  product_id INT DEFAULT NULL,
  device_type VARCHAR(15) DEFAULT NULL,
  traffic_source VARCHAR(20) DEFAULT NULL,
  campaign_id INT DEFAULT NULL,
  page_category VARCHAR(20) DEFAULT NULL,
  session_duration_sec DECIMAL(10,1) DEFAULT NULL,
  experiment_group VARCHAR(10) DEFAULT NULL,
  PRIMARY KEY (timestamp, customer_id)
  );



-- Products table

CREATE TABLE marketing_and_ecommerce_analysis.products (
  product_id INT PRIMARY KEY,
  category VARCHAR(20) DEFAULT NULL,
  brand VARCHAR(20) DEFAULT NULL,
  base_price DECIMAL(10,2) DEFAULT NULL,
  launch_date DATE DEFAULT NULL,
  is_premium INT DEFAULT NULL
);
  
  
  
  -- Transactions table
  

CREATE TABLE marketing_and_ecommerce_analysis.transactions (
  transaction_id INT NOT NULL,
  timestamp TIMESTAMP NOT NULL,
  customer_id INT NOT NULL,
  product_id INT DEFAULT NULL,
  quantity INT DEFAULT NULL,
  discount_applied DECIMAL(10,2) DEFAULT NULL,
  gross_revenue DECIMAL(10,2) DEFAULT NULL,
  campaign_id INT DEFAULT NULL,
  refund_flag INT DEFAULT NULL,
  PRIMARY KEY (timestamp,customer_id)
 );





  
  