use fda;
---------------------------------------------------------------------------------------------------------------------------------------
SELECT count(ApplNo),ActionType FROM regactiondate group by ActionType;
---------------------------------------------------------------------------------------------------------------------------------------
-- Task 1
-- 1. Determine the number of drugs approved each year and provide insights into the yearly trends.
-- Solution 
Select  Year(ActionDate)as years,Count(ActionType) FROM regactiondate
 where ActionType= 'AP' and ActionDate is not null Group by years order by years;
--------------------------------------------------------------------------------------------------------------------
-- 2. Identify the top three years that got the highest and lowest approvals, in descending and ascending order, respectively
-- Solution
-- Highest
Select  Year(ActionDate)as years,Count(ActionType) AS number_of_approved_drugs1
			 FROM regactiondate where ActionType= 'AP' Group by years order by number_of_approved_drugs1 DESC Limit 3
-- Lowest             
Select  Year(ActionDate)as years,Count(ActionType) AS number_of_approved_drugs1
			 FROM regactiondate where ActionType= 'AP' and ActionDate is not null Group by years order by number_of_approved_drugs1 ASC Limit 3     
  ------------------------------------------------------------------------------------------------------------------
  -- 3. Explore approval trends over the years based on sponsors. 
  -- Solution
Select Year(ActionDate) as Years ,SponsorApplicant,Count(SponsorApplicant) as NumberOfApprovals from Application
 join RegActionDate on
  RegActionDate.ApplNo=Application.ApplNo
  where Application.ActionType= "AP" and Year(ActionDate) is not null
  group by SponsorApplicant,Years order by Years,SponsorApplicant;
  
  
  ---------------------------------------------------------------------------------------------------------------
  -- 4. Rank sponsors based on the total number of approvals they received each year between 1939 and 1960.
  -- Solution 
  SELECT
    a.SponsorApplicant,
    YEAR(r.ActionDate) as year_approved,
    COUNT(r.ActionType) as num_approvals,
    RANK() OVER (PARTITION BY YEAR(r.ActionDate) ORDER BY COUNT(r.ActionType) DESC) as sponsor_rank
FROM
    regactiondate r
JOIN
    application a ON a.ApplNo = r.ApplNo
WHERE
    YEAR(r.ActionDate) BETWEEN 1939 AND 1960
    AND r.ActionType = 'AP'  -- Assuming 'AP' represents approvals
GROUP BY
    a.SponsorApplicant, YEAR(r.ActionDate)
ORDER BY
    YEAR(r.ActionDate), sponsor_rank;
    
---------------------------------------------------------------------------------------------------------------------------------------

-- Task 2

-- 1 Group products based on MarketingStatus. Provide meaningful insights into the segmentation patterns.
-- Solution
SELECT * FROM fda.product;

Select ProductMktStatus, count(drugname) as No_Of_Products from product group by ProductMktStatus;

----------------------------------------------------------------------------------------------------------------------------------------

-- 2 Calculate the total number of applications for each MarketingStatus year-wise after the year 2010
-- Solution

Select YEAR(regactiondate.ActionDate),ProductMktStatus, count(product.ApplNo) 
from product join regactiondate on product.ApplNo=regactiondate.ApplNo 
 where  YEAR(regactiondate.ActionDate) >2010 group by ProductMktStatus,YEAR(regactiondate.ActionDate) 
 order by YEAR(regactiondate.ActionDate),ProductMktStatus;

--------------------------------------------------------------------------------------------------------------------
-- 3. Identify the top MarketingStatus with the maximum number of applications and analyze its trend over time.

-- Solution 
-- Top Marketing Status

Select ProductMktStatus, max(ApplNo) FROM  product
group by ProductMktStatus order by ProductMktStatus  Limit 1 ;

Select YEAR(regactiondate.ActionDate),ProductMktStatus, max(product.ApplNo) FROM  product
 join regactiondate on product.ApplNo=regactiondate.ApplNo where ProductMktStatus= 1 and
 YEAR(regactiondate.ActionDate) is not null
group by YEAR(regactiondate.ActionDate) 
 order by  YEAR(regactiondate.ActionDate) ;
-----------------------------------------------------------------------------------------------------------
-- Task 3
SELECT * FROM fda.application;
-- 1. Categorize Products by dosage form and analyze their distribution.
-- Solution
select * from product;
Select form,count(form) as distribution from product group by form order by distribution Desc;


-- 2. Calculate the total number of approvals for each dosage form and identify the most successful forms
-- Solution

Select  form,count(Application.ActionType) as TotalNumberOfApprovals from product 
join Application on Application.ApplNo=product.ApplNo 
where Application.ActionType= 'AP' group by form order by TotalNumberOfApprovals desc;

-- 3. Investigate yearly trends related to successful forms. 
-- Solution

With TopForm as
(Select form,count(form) as distribution  from product group by form 
order by distribution  desc limit 5 )
Select YEAR(regactiondate.ActionDate),tf.form,count(tf.form) as totalform from TopForm as tf
join product on tf.form=product.form join regactiondate on product.ApplNo=regactiondate.ApplNO
Where YEAR(regactiondate.ActionDate) is not null
group by YEAR(regactiondate.ActionDate),tf.form order by  YEAR(regactiondate.ActionDate),tf.form;

-- Task4
-- 1. Analyze drug approvals based on therapeutic evaluation code (TE_Code).
Select TECODE,count(a.ActionType) as No_Of_Approvals 
from product_tecode as p join application as a on p.ApplNo=a.ApplNo
where a.ActionType= 'AP' and TECODE is not null
group by TECODE order by No_Of_Approvals desc ;


-- 2. Determine the therapeutic evaluation code (TE_Code) with the highest number of Approvals in each year.

Select Approve_Year,TECODE,No_Of_Approvals FROM
(Select YEAR(regactiondate.ActionDate) as Approve_Year,pt.TECODE,count(pt.Applno) as No_Of_Approvals, 
row_number() over (partition by Year(regactiondate.ActionDate) order by  count(*) desc) as RN
from product_tecode as pt join application as a on pt.ApplNo=a.ApplNo
join regactiondate on a.ApplNo=regactiondate.ApplNo
where  regactiondate.DocType= 'N' 
group by YEAR(regactiondate.ActionDate),pt.TECODE
) as ranked
where RN=1;