-- CHECK FOR THE NUMBER OF ROWS PRESENT IN TABLE
select count(*) from zepto_v2

-- SELECT TOP 10 RECORDS
select top 10 * from zepto_v2

--CHECK FOR NULL PRESENT
select * from zepto_v2
where name is null
or 
mrp is null
or
discountedSellingPrice is null
or
discountPercent is null
or
weightInGms is null
or
outOfStock is null
or
quantity is null

--CHECK FOR AVAILABLE CATEGORIES
select distinct category from zepto_v2 order by Category

--CHECK FOR AVAILABLE QUANTITY BY CATEGORY
select Category, sum(availableQuantity)as [available quantity] 
from zepto_v2
group by Category
order by [available quantity] desc

--ADDED Primary Key
ALTER TABLE zepto_v2
ADD sku_id INT IDENTITY(1,1) PRIMARY KEY;

select 
	name,
	Category,
	count(sku_id) as 'No_of_Occurance'
from zepto_v2
group by name,Category
having count(sku_id)>1


--CONVERTING MRP,DISCOUNTEDSELLINGPRICE FORM PAISE TO RUPEES
update zepto_v2 set mrp = mrp/100
update zepto_v2 set discountedSellingPrice = discountedSellingPrice/100

-- Top 10 best value products based on the discount percentage
SELECT DISTINCT TOP 10
	NAME, MRP, DISCOUNTPERCENT
FROM zepto_v2
ORDER BY discountPercent DESC
-- Top 10 best value products based on the discount percentage
--second approach
SELECT TOP 10
       NAME,
       MRP,
       MAX(DISCOUNTPERCENT) AS DISCOUNTPERCENT
FROM zepto_v2
GROUP BY NAME, MRP
ORDER BY DISCOUNTPERCENT DESC;


--what are the products with high MRP but out of stock
SELECT 
	DISTINCT NAME,
	MRP
FROM zepto_v2
WHERE outOfStock = 'TRUE' 
AND 
MRP > (SELECT AVG(mrp)FROM zepto_v2)
ORDER BY MRP DESC

--Q3 CALCULATE ESTIMATED REVENUE FOR EACH CATEGORY
SELECT CATEGORY,
SUM(DISCOUNTEDSELLINGPRICE * AVAILABLEQUANTITY) AS POTENTIAL_REVENUE
FROM zepto_v2
GROUP BY Category
ORDER BY POTENTIAL_REVENUE 

--Q4. FIND ALL PRODUCTS WHERE MRP IS GREATER THAN 500 AND DISCOUNT IS LESS THAN 10%
SELECT 
	NAME,
	MRP,
	discountPercent
FROM zepto_v2
WHERE MRP>500 AND discountPercent <10
ORDER BY NAME,MRP DESC


--Q5 IDENTIFY THE TOP 5 CATEGORIES OFFERING THE HIGHEST AVERAGE DISCOUNT PERCENTAGE
SELECT TOP 5
	CATEGORY,
	ROUND(AVG(discountpercent),2) as highest_avg_discount
FROM ZEPTO_V2
GROUP BY CATEGORY
ORDER BY highest_avg_discount DESC

--Q6 FIND THE PRICE PER GRAM FOR PRODUCTS ABOVE 100g AND SORT BY BEST VALUE.
SELECT DISTINCT 
	NAME,
	discountedSellingPrice,
	weightInGms,
	ROUND(discountedSellingPrice/weightInGms,2) as price_per_gram
FROM zepto_v2
WHERE weightInGms >= 100


-- Q7 Group the product into categories like Low, Medium, Bulk
SELECT 
	NAME,
	quantity,
	CASE 
		WHEN QUANTITY < 50 THEN 'LOW'
		WHEN QUANTITY BETWEEN 50 AND 150 THEN 'MEDIUM'
		ELSE 'BULK'
	END AS PRODUCT_CATEGORY
FROM zepto_v2
ORDER BY quantity DESC, PRODUCT_CATEGORY


--Q8 WHAT IS TOTAL INVENTORY WEIGHT PER CATEGORY
SELECT 
	Category,
	SUM(AVAILABLEQUANTITY) AS TOTAL_AVAILABEL_QUANTITY
FROM zepto_v2
GROUP BY Category
ORDER BY TOTAL_AVAILABEL_QUANTITY DESC