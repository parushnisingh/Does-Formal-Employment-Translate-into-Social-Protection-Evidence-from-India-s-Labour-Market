
USE PLFS;
GO

-- 1. Overall social protection rate
SELECT 
    COUNT(*) AS total_workers,
    SUM(CAST(social_prot AS INT)) AS protected_workers,
    ROUND(100.0 * SUM(CAST(social_prot AS INT)) / COUNT(*), 2) AS protection_rate_pct
FROM workers;

-- 2. Social protection by contract type
SELECT 
    CASE job_pas
        WHEN 1 THEN 'Written contract'
        WHEN 2 THEN 'Oral fixed-term'
        WHEN 3 THEN 'Oral non-fixed'
        WHEN 4 THEN 'No contract'
    END AS contract_type,
    COUNT(*) AS workers,
    ROUND(100.0 * SUM(CAST(social_prot AS INT)) / COUNT(*), 2) AS protection_rate_pct
FROM workers
WHERE job_pas IS NOT NULL
GROUP BY job_pas
ORDER BY job_pas;

-- 3. Urban vs rural gap
SELECT 
    CASE WHEN urban = 1 THEN 'Urban' ELSE 'Rural' END AS location,
    COUNT(*) AS workers,
    ROUND(100.0 * SUM(CAST(social_prot AS INT)) / COUNT(*), 2) AS protection_rate_pct
FROM workers
GROUP BY urban
ORDER BY urban;

-- 4. Education gradient
SELECT 
    CASE edu_num
        WHEN 1  THEN 'Not literate'
        WHEN 5  THEN 'Below primary'
        WHEN 6  THEN 'Primary'
        WHEN 7  THEN 'Middle'
        WHEN 8  THEN 'Secondary'
        WHEN 10 THEN 'Higher secondary'
        WHEN 11 THEN 'Diploma'
        WHEN 12 THEN 'Graduate'
        WHEN 13 THEN 'Postgraduate'
    END AS education_level,
    COUNT(*) AS workers,
    ROUND(100.0 * SUM(CAST(social_prot AS INT)) / COUNT(*), 2) AS protection_rate_pct
FROM workers
WHERE edu_num IS NOT NULL
GROUP BY edu_num
ORDER BY edu_num;

-- 5. State ranking with names (JOIN)
SELECT 
    s.state_name,
    COUNT(*) AS workers,
    ROUND(100.0 * SUM(CAST(w.social_prot AS INT)) / COUNT(*), 2) AS protection_rate_pct
FROM workers w
JOIN state_names s ON w.st = s.state_code
GROUP BY s.state_name
ORDER BY protection_rate_pct DESC;

-- 6. Contract paradox -- private sector only
SELECT 
    CASE job_pas
        WHEN 1 THEN 'Written contract'
        WHEN 2 THEN 'Oral fixed-term'
        WHEN 3 THEN 'Oral non-fixed'
        WHEN 4 THEN 'No contract'
    END AS contract_type,
    COUNT(*) AS workers,
    ROUND(100.0 * SUM(CAST(social_prot AS INT)) / COUNT(*), 2) AS protection_rate_pct
FROM workers
WHERE job_pas IS NOT NULL
AND etyp_num != 5
GROUP BY job_pas
ORDER BY job_pas;
