--- You are a data analyst at an e-commerce company similar to Amazon. Your leadership wants insights on customer behavior, product performance, and order dynamics. The dataset mimics a real-world transactional system.


CREATE TABLE Orders(
	Order_Id INT PRIMARY KEY,
	Customer_id INT,
	Order_date DATE,
	Total_Amount DECIMAL
);
CREATE TABLE Customers(
	Customer_id INT PRIMARY KEY,
	Customer_Name VARCHAR(50),
	Region VARCHAR (20),
	SignUp_date DATE
);
CREATE TABLE Order_items (
	Order_Id INT,
	Product_id INT,
	Quantity INT,
	Item_price DECIMAL
);
CREATE TABLE Products (
	Product_id INT PRIMARY KEY,
	PRODUCT_NAME VARCHAR(50),
	Catgeory VARCHAR(50),
	PRICE DECIMAL(10,2)
);

ALTER TABLE Orders ADD CONSTRAINT FK_Orders_Customers FOREIGN KEY (Customer_id) REFERENCES Customers(Customer_id);
ALTER TABLE Order_items ADD CONSTRAINT FK_Order_items_ID FOREIGN KEY (Order_Id) REFERENCES Orders(Order_Id);
ALTER TABLE Order_items ADD CONSTRAINT FK_Product_items FOREIGN KEY (Product_id) REFERENCES Products(Product_id);

INSERT INTO Customers (Customer_id, Customer_Name, Region, SignUp_date) VALUES
(1, 'Alice Johnson', 'North', '2022-01-10'),
(2, 'Bob Smith', 'South', '2022-02-15'),
(3, 'Charlie Davis', 'East', '2022-03-20'),
(4, 'Diana Prince', 'West', '2022-04-25'),
(5, 'Ethan Clark', 'North', '2022-05-30'),
(6, 'Fiona Adams', 'South', '2022-06-10'),
(7, 'George King', 'East', '2022-07-18'),
(8, 'Hannah Lewis', 'West', '2022-08-12'),
(9, 'Ian White', 'North', '2022-09-22'),
(10, 'Julia Hall', 'East', '2022-10-30');

INSERT INTO Products (Product_id, PRODUCT_NAME, Catgeory, PRICE) VALUES
(101, 'Wireless Mouse', 'Electronics', 25.99),
(102, 'Gaming Keyboard', 'Electronics', 45.50),
(103, 'Bluetooth Speaker', 'Audio', 35.00),
(104, 'Running Shoes', 'Footwear', 70.00),
(105, 'Backpack', 'Accessories', 40.00),
(106, 'Water Bottle', 'Accessories', 15.00),
(107, 'Yoga Mat', 'Fitness', 20.00),
(108, 'Smart Watch', 'Electronics', 120.00),
(109, 'LED Monitor', 'Electronics', 150.00),
(110, 'Notebook Set', 'Stationery', 10.00);

INSERT INTO Orders (Order_Id, Customer_id, Order_date, Total_Amount) VALUES
(1001, 1, '2023-01-05', 95.99),
(1002, 2, '2023-01-15', 45.50),
(1003, 3, '2023-02-01', 150.00),
(1004, 4, '2023-02-20', 70.00),
(1005, 5, '2023-03-10', 60.00),
(1006, 6, '2023-03-25', 140.00),
(1007, 7, '2023-04-05', 80.00),
(1008, 8, '2023-04-18', 35.00),
(1009, 9, '2023-05-01', 100.00),
(1010, 10, '2023-05-15', 30.00);

INSERT INTO Order_items (Order_Id, Product_id, Quantity, Item_price) VALUES
(1001, 101, 1, 25.99),
(1001, 105, 1, 40.00),
(1001, 106, 2, 15.00),
(1002, 102, 1, 45.50),
(1003, 109, 1, 150.00),
(1004, 104, 1, 70.00),
(1005, 105, 1, 40.00),
(1005, 107, 1, 20.00),
(1006, 108, 1, 120.00),
(1006, 106, 2, 10.00),
(1007, 107, 2, 20.00),
(1007, 110, 4, 10.00),
(1008, 103, 1, 35.00),
(1009, 109, 1, 150.00),
(1009, 106, 1, 15.00),
(1010, 110, 3, 10.00),
(1001, 110, 2, 10.00),
(1002, 106, 2, 15.00),
(1003, 102, 1, 45.50),
(1004, 103, 1, 35.00),
(1005, 101, 1, 25.99),
(1006, 101, 1, 25.99),
(1007, 108, 1, 120.00),
(1008, 105, 1, 40.00),
(1009, 102, 1, 45.50),
(1010, 103, 1, 35.00),
(1010, 107, 1, 20.00),
(1003, 101, 1, 25.99),
(1004, 110, 2, 10.00),
(1002, 107, 1, 20.00);

--- EASY LEVEL 
-- Q1: Total revenue per customer (Easy)

Select Customer_id,SUM(Total_Amount) as Total_Revenue 
from Orders
GROUP BY Customer_id;

--- Q2: Total revenue per category (Easy)

select p.Catgeory,SUM(oi.Quantity*oi.Item_price) as Category_revenue
from Order_items oi
JOIN Products p on oi.Product_id=p.Product_id
GROUP BY p.Catgeory;

---Moderate level
--- Q3: Top 3 categories by revenue in the last 90 days (Moderate)

select TOP 3 P.Catgeory,SUM(OI.Quantity*OI.Item_price) as total_revenue
from Orders O
JOIN Order_items oi on O.Order_Id=oi.Order_Id
JOIN Products p on oi.Product_id=p.Product_id
WHERE O.Order_date >= DATEADD(DAY,-90,'2023-05-15')
GROUP BY P.Catgeory
ORDER BY total_revenue desc;


-- Q4: Number of unique customers per category (Moderate)

SELECT p.Catgeory,COUNT(DISTINCT o.Customer_id) as unique_customers
from Orders o
JOIN Order_items oi on o.Order_Id=oi.Order_Id
JOIN Products p on p.Product_id=oi.Product_id
GROUP BY p.Catgeory
Order by unique_customers desc;

--- Q5: Monthly revenue trend per category (Moderate)
Select MONTH(o.Order_date) as month ,p.Catgeory,
SUM(oi.Quantity*oi.Item_price) as monthly_revenue
FROM Orders o
JOIN Order_items oi ON o.Order_Id=oi.Order_Id
JOIN Products p ON oi.Product_id=p.Product_id
GROUP BY MONTH(o.Order_date),p.Catgeory
Order By month,Catgeory

---Q6: Rank products by revenue within each category (Hard)
Select P.PRODUCT_NAME,P.Catgeory,SUM(oi.Quantity*oi.Item_price) as Revenue,
RANK() OVER (PARTITION BY P.Catgeory Order by SUM(oi.Quantity*oi.Item_price) DESC) as Revenue_rank
from Order_items oi
JOIN Products P on oi.Product_id=P.Product_id
Group By P.PRODUCT_NAME,P.Catgeory

--Q7: Identify customers who placed multiple high-value orders (> $100) (Hard)

Select Customer_id 
from Orders
where Total_Amount > 100
Group by Customer_id 
HAVING COUNT(*) > 1

--Q8: Days since the last order per customer (Hard - Window Function)

Select Customer_id,Order_Id,Order_date,
	   DATEDIFF(DAY,Order_date,LAG(Order_date) OVER (PARTITION BY Customer_id Order by order_date)) as days_since_last_order
from Orders;

-- Q9: First product ordered by each customer (Very Hard)
-- This will give multiple products as multiple products can be ordered by 1 orderId
WITH customer_first_order AS (
    SELECT Customer_id, MIN(Order_date) AS first_order_date
    FROM Orders
    GROUP BY Customer_id
),
joined_data AS (
    SELECT o.Customer_id, o.Order_id, o.Order_date, oi.Product_id, p.Product_name
    FROM Orders o
    JOIN Order_items oi ON o.Order_id = oi.Order_Id
    JOIN Products p ON oi.Product_id = p.Product_id
)
SELECT cf.Customer_id,j.Order_Id, j.Product_id, j.Product_name
FROM joined_data j
JOIN customer_first_order cf 
    ON j.Customer_id = cf.Customer_id 
    AND j.Order_date = cf.first_order_date;

-- Customer first order within order_id
with customer_first_order as (
SELECT
	o.Customer_id,
	o.Order_Id,
	o.Order_date,
	oi.Product_id,
	p.PRODUCT_NAME,
	ROW_NUMBER() OVER (PARTITION BY o.Customer_id Order by o.Order_date,o.Order_id ) as rnk
FROM Orders o
JOIN Order_items oi ON o.Order_Id=oi.Order_Id
JOIN Products p ON oi.Product_id=p.Product_id
)
select Customer_id,Product_id,PRODUCT_NAME
from customer_first_order
where rnk=1;

-- Q10: Most popular product in each region (Very Hard)

SELECT c.Region,p.PRODUCT_NAME,COUNT(*) as order_count,
		 DENSE_RANK() OVER (PARTITION BY c.region ORDER BY COUNT(*) DESC) as region_rank
from Customers c
JOIN Orders o ON c.Customer_id=o.Customer_id
JOIN Order_items oi ON oi.Order_Id=o.Order_Id
JOIN Products p On oi.Product_id=p.Product_id
GROUP BY c.Region,p.PRODUCT_NAME

--- Q11: Detect returning customers within 30 days of last order (Very Hard - Self Join)

select a.customer_id,a.order_id AS current_order,b.order_id AS previous_order,
       DATEDIFF(DAY,a.order_date,b.order_date) as days_between
FROM Orders a
JOIN Orders b ON a.Customer_id=b.Customer_id AND b.Order_date < a.Order_date
WHERE DATEDIFF(DAY,a.order_date,b.order_date) <=30;

-- Q12: Detect revenue spikes using moving average (Very Hard - Window Function)
SELECT Order_date,SUM(Total_Amount) as daily_revenue,
AVG(SUM(Total_Amount)) OVER (ORDER BY Order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as weekly_avg
FROM Orders
GROUP BY Order_date