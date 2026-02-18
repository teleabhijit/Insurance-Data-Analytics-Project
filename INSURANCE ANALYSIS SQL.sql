Select * From customers;
Select * From policies;
Select * From claims;
Select * From payments;

-- KPI: Total number of policies
SELECT 
    COUNT(*) AS Total_Policies FROM policies;

-- KPI: Total number of customers
SELECT 
    COUNT(*) AS Total_Customers FROM customers;

-- KPI: Total premium amount collected
SELECT 
    ROUND(SUM(`premium amount`), 2) AS Total_Premium_Amount FROM policies;

-- Total Claim Amount
SELECT SUM(`Claim Amount`) AS Claim_Amount FROM claims;

-- Claim Approval Rate
SELECT 
ROUND(
SUM(CASE WHEN `Claim Status`='Approved' THEN 1 ELSE 0 END)
/ COUNT(*) * 100, 2) AS `Claim Approval Rate` FROM claims;

-- Policy type wise policy count
SELECT 
    `Policy Type`,
    COUNT(*) AS Policy_Count
FROM policies GROUP BY `Policy Type`;

--  Gender Wise Policy Count
SELECT 
    Gender,
    COUNT(*) AS Policy_Count
FROM customers c
JOIN policies p 
ON c.`Customer ID` = p.`Customer ID` GROUP BY Gender;

-- Age Bucket Wise Policy Count
SELECT 
    `Age Bucket`,
    COUNT(*) AS Policy_Count
FROM customers c
JOIN policies p 
ON c.`Customer ID` = p.`Customer ID`GROUP BY `Age Bucket`;

-- Claim Status Wise Policy Count
SELECT 
    `Claim Status`,
    COUNT(*) AS Claim_Count
FROM claims
GROUP BY `Claim Status`;

-- Payment Status Wise Policy Count
SELECT 
    `Payment Status`,
    COUNT(*) AS Payment_Count
FROM payments
GROUP BY `Payment Status`;


-- Premium Growth Rate

SELECT
    curr.`Policy Year` AS `Policy Year`,
    ROUND(curr.total_premium, 2) AS `Total Premium`,
    ROUND(
        ((curr.total_premium - prev.total_premium) / prev.total_premium) * 100,
        2
    ) AS `Premium Growth Rate (%)`
FROM
    (
        SELECT
            `Policy Year`,
            SUM(`Premium Amount`) AS total_premium
        FROM policies
        GROUP BY `Policy Year`
    ) curr
LEFT JOIN
    (
        SELECT
            `Policy Year`,
            SUM(`Premium Amount`) AS total_premium
        FROM policies
        GROUP BY `Policy Year`
    ) prev
ON curr.`Policy Year` = prev.`Policy Year` + 1
ORDER BY curr.`Policy Year`;


-- Premium vs Claim by Year (extra KPI)
SELECT
    YEAR(p.`Policy Start Date`) AS policy_year,
    ROUND(SUM(p.`Premium Amount`), 0) AS total_premium,
    ROUND(SUM(c.`Claim Amount`), 0) AS total_claim
FROM policies p
LEFT JOIN claims c
    ON p.`Policy ID` = c.`Policy ID`
GROUP BY YEAR(p.`Policy Start Date`)
ORDER BY policy_year;


-- Policy Status Distribution
SELECT 
    Status,
    COUNT(*) AS Policy_Count
FROM policies
GROUP BY Status;

-- Yearly Policy Issuance Trend
SELECT 
    `Policy Year`,
    COUNT(*) AS Policy_Count
FROM policies
GROUP BY `Policy Year`
ORDER BY `Policy Year`;

-- Policies Expiring This Year
SELECT
    `Policy Year`,
    COUNT(*) AS Expiring_Policy_Count
FROM policies
WHERE `Expire This Year` = 'Yes'
GROUP BY `Policy Year`
ORDER BY `Policy Year`;
