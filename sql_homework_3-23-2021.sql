--Simple Queries

--shows name, product line, and buy price by most expensive first
SELECT productName AS "Name", productLine AS "Product Line", buyPrice AS "Buy Price" FROM products ORDER BY buyPrice DESC;

--shows first name, last name, and city from anyone from germany by last name asc
SELECT contactFirstName AS "First Name", contactLastName AS "Last Name", city AS "City" FROM customers WHERE country = "Germany" ORDER BY contactLastName ASC;

--shows unique values of status alphabetically limit 6 results
SELECT DISTINCT STATUS FROM orders ORDER BY STATUS ASC LIMIT 6;

--shows shows payments made on or after july 1, 2005 sorted by increasing payment
SELECT * FROM payments WHERE paymentDate >= '2005-01-01' ORDER BY amount ASC;

-- shows last name, first name, email, and job title of employees from san francisco. sorted by last name
SELECT e.lastName, e.firstName, e.email, e.jobTitle FROM employees AS e JOIN offices AS o ON e.officeCode = o.officeCode WHERE o.city = "San Francisco" ORDER BY e.lastName;

--shows name, product line, scale, and vendor fo all car products vintage and classic. displays all vintage and classic and sorted by name
SELECT productName, productLine, productScale, productVendor FROM products WHERE productLine IN ('Vintage Cars', 'Classic Cars') GROUP BY productName ASC;

--Joins and Grouping

--shows customer name and sales rep assigned to them sorted by customer name
SELECT c.customerName AS "Customer Name" , concat(e.lastName, ', ', e.firstName) AS "Sales Rep" FROM customers AS c JOIN employees AS e ON c.salesRepEmployeeNumber = e.employeeNumber ORDER BY c.customerName asc;  

-- supposed to show product names, total ordered per product and total sales per product
SELECT p.productName AS 'Product Name', (SELECT sum(quantityOrdered)) AS 'Total # Ordered', (SELECT sum(quantityOrdered * priceEach)) AS 'Total Sale'
FROM products AS p JOIN orderdetails AS o ON p.productCode = o.productCode 
GROUP BY p.productname
order BY 3 desc;

--shows order status and number of each orders with that status
SELECT DISTINCT STATUS AS 'Order Status', COUNT(*) AS '# Orders' FROM orders GROUP BY status;

--shows product lines and number of products sold per line. sorted by products sold desc
SELECT p.productLine AS 'Product Line', (SELECT sum(o.quantityOrdered) WHERE p.productCode = o.productCode) AS '# Sold'
FROM products AS p JOIN orderdetails AS o ON p.productCode = o.productCode
group BY p.productLine
ORDER BY sum(o.quantityOrdered) desc;

--shows each sales rep their total orders and the total amount of those orders 
SELECT concat(e.lastName, ', ', e.firstName) AS 'Sales rep', COUNT(distinct o.customerNumber) AS 'Total # Ordered', 
coalesce( sum(distinct od.quantityOrdered * od.priceEach) , 0) AS 'Total Sale' 
FROM employees AS e 
LEFT JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber 
LEFT JOIN orders o ON o.customerNumber = c.customerNumber 
LEFT JOIN orderdetails od ON o.orderNumber = od.orderNumber
WHERE e.jobTitle = "Sales Rep"
GROUP BY e.employeeNumber
ORDER BY 3 DESC;

--shows the month, year and total sales for that month
SELECT DATE_FORMAT(paymentDate, '%M') AS 'Month', DATE_FORMAT(paymentDate, '%Y') AS 'Year', FORMAT(SUM(amount), 2) AS 'Payments Recieved'
FROM payments
GROUP BY 1, 2 ORDER BY 2 ASC, 1 ASC;

-- Banking Queries

-- shows product name and product type
SELECT NAME AS 'Product', product_type_cd AS 'Type'
FROM product
GROUP BY 1;

-- shows branch name and city along with employees last name and job title for each branch
SELECT b.name AS 'Branch Name', b.city AS 'Branch City', e.last_name AS 'Employee Last Name', e.title AS 'Employee Title'
FROM branch AS b JOIN employee AS e ON b.branch_id = e.assigned_branch_id
ORDER BY b.name;

-- shows a list of each unique employee title
SELECT DISTINCT title FROM employee;

-- shows last name and title of each employee and the last namea nd title of their boss
SELECT e.last_name AS 'Employee Last name', e.title AS 'Employee Title', m.last_name AS 'Boss Last Name', m.title AS 'Boss Title'
FROM employee AS e JOIN employee AS m ON e.superior_emp_id = m.emp_id
ORDER BY e.last_name;

-- shows name of account's product, available balance, and customer's last name
SELECT p.name AS 'Product Name', a.avail_balance AS 'Available Balance', i.last_name AS 'Customer Last Name'
FROM account AS a
JOIN product AS p ON a.product_cd = p.product_cd
JOIN individual AS i ON i.cust_id = a.cust_id
ORDER BY p.name;

-- shows all account transaction details for individual customers whose last name starts with 'T'.
SELECT i.last_name, ac.amount, ac.funds_avail_date, ac.txn_date, ac.txn_type_cd
FROM acc_transaction AS ac
JOIN account AS a ON a.account_id = ac.account_id
JOIN individual AS i ON a.cust_id = i.cust_id
WHERE i.last_name LIKE 't%';