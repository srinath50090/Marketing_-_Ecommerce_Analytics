

-- Events table stores:
			-- Event ID,
			-- Timestamp of when the event happened,
			-- Which customer saw which page, using which device,
			-- What product they saw, purchased, viewed, or clicked,
			-- Their actions, such as whether they purchased, added the product to the cart, clicked, or just viewed it,
			-- Their traffic source, such as whether they searched for a product organically or came through a campaign source,
			-- How much time they spent in a session.


-- Transactions table stores (Purchase events):
			-- Transaction ID,
			-- Which customer made a purchase and at what time,
			-- Which product they purchased,
			-- How many quantities they ordered,
			-- How much discount the customer received for the transaction,
			-- How much revenue was generated from the transaction,
			-- Whether they returned any product or not.


-- There are some nulls in the product_id column in the Events table, 
-- which are not important because a customer may only enter the home page and exit from the app or website without clicking on any product. 
-- So, null values may be created due to this reason or some other reasons.

-- But, in the Transactions table (Purchase Events table), there are some nulls in the product_id column, 
-- which is not good because a person cannot make a purchase without a product. 
-- So, having a null product_id in a transaction is more serious.

-- We need to rectify this problem with the concerned team. 
-- We should not take these transactions for analysis, 
-- as this could lead to incorrect analysis and incorrect business decisions.

-- So i decided to leave the records for analysis whereever the product_id is null and event_type is purchase in the Events and Transactions table



-- Creating Events table as view

CREATE VIEW marketing_and_ecommerce_analysis.events_vw AS			
SELECT 
e.* 
FROM marketing_and_ecommerce_analysis.events e 
WHERE 
			e.product_id IS NOT NULL OR
			e.event_type <> "purchase"
			
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------		
			

-- In the real-time database, when a customer makes a purchase, it is recorded and contributes to the revenue. 
-- After the purchase, if the customer returns the product, it is also recorded with a negative revenue value, 
-- so the net effect is zero.

-- However, in this case, there are no purchase entries for these returned products. 
-- Only the return entries are being recorded with negative revenue, which affects the overall revenue negatively.
-- Therefore, when we calculate the correct revenue, we must exclude these return records wherever the corresponding purchase records are missing.



-- Creating Transactions table as view
			
CREATE VIEW marketing_and_ecommerce_analysis.transactions_vw AS			
SELECT 
t.*
FROM marketing_and_ecommerce_analysis.transactions t 
WHERE 
			t.product_id IS NOT NULL AND 
			t.refund_flag = 0


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- The Campaigns table stores :
			-- Campaign ID, 
			-- Channel, 
			-- Objective, 
			-- start and end dates, 
			-- Targeted Segment, and 
			-- Expected Uplift (the percentage revenue increase during the campaign period). 

-- However, there is no information about the campaign name or the cost of the campaign. 
-- Therefore, when dealing with campaign data, we can only use the Campaign ID instead of the campaign name.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- The Customer table stores :
			-- Customer ID, 
			-- Age, 
			-- Gender, 
			-- Country of the customer, 
			-- sign-up date, and 
			-- Acquisition Channel (how they were acquired). 

-- However, there is no information about the customer's name or contact details. 
-- Therefore, when dealing with customer data, we can only use the Customer ID to represent the customer.


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- The Product table stores :
			-- Product ID, 
			-- Category, 
			-- Brand, 
			-- Price, 
			-- Launch date, and 
			-- whether the product is premium or not. 

-- However, there is no information about the product name or description. 
-- Therefore, when dealing with product data, we can only use the Product ID to represent the product.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------