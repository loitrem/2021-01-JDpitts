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
SELECT productName, productLine, productScale, productVendor FROM products GROUP BY productName ASC HAVING productLine = "Vintage Cars" or productLine = "Classic Cars";

--Joins and Grouping

--shows customer name and sales rep assigned to them sorted by customer name
SELECT c.customerName AS "Customer Name" , concat(e.lastName, ', ', e.firstName) AS "Sales Rep" FROM customers AS c JOIN employees AS e ON c.salesRepEmployeeNumber = e.employeeNumber ORDER BY c.customerName asc;  

-- supposed to show product names, total ordered per product and total sales per product
SELECT p.productName AS 'Product Name', (SELECT sum(quantityOrdered)) AS 'Total # Ordered', (SELECT sum(quantityOrdered * priceEach)) AS 'Total Sale'
FROM products AS p JOIN orderdetails AS o ON p.productCode = o.productCode 
GROUP BY p.productname
order BY sum(quantityOrdered * priceEach) desc;

--shows order status and number of each orders with that status
SELECT DISTINCT STATUS AS 'Order Status', COUNT(*) AS '# Orders' FROM orders GROUP BY status;

--shows product lines and number of products sold per line. sorted by products sold desc
SELECT p.productLine AS 'Product Line', (SELECT sum(o.quantityOrdered) WHERE p.productCode = o.productCode) AS '# Sold'
FROM products AS p JOIN orderdetails AS o ON p.productCode = o.productCode
group BY p.productLine
ORDER BY sum(o.quantityOrdered) desc;

--shows each sales rep their total orders and the total amount of those orders -- not done
SELECT concat(e.lastName, ', ', e.firstName) AS 'Sales rep', 
(select COUNT(distinct o.customerNumber) WHERE c.salesRepEmployeeNumber = e.employeeNumber AND o.customerNumber = c.customerNumber) AS 'Total # Ordered', 
(select sum(distinct od.quantityOrdered * od.priceEach) WHERE od.orderNumber = o.orderNumber AND o.customerNumber = c.customerNumber) AS 'Total Sale' 
FROM employees AS e JOIN (orders AS o , customers AS c, orderdetails AS od) ON (c.customerNumber = o.customerNumber AND c.salesRepEmployeeNumber = e.employeeNumber AND o.orderNumber = od.orderNumber)
WHERE e.jobTitle = 'Sales Rep'
GROUP BY concat(e.lastName, ', ', e.firstName)
ORDER BY sum(od.quantityOrdered * od.priceEach) DESC;
