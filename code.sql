/*
Query to find the number of distinct campaigns
*/

SELECT COUNT(DISTINCT utm_campaign) AS 'Number of Distinct Campaigns'
FROM page_visits;

/*
Query to find the number of distinct sources
*/

SELECT COUNT(DISTINCT utm_source) AS 'Number of Distinct Sources'
FROM page_visits;

/*
Query to find relationship between campaigns and sources
*/

SELECT DISTINCT utm_campaign AS 'Campaign Name',
	utm_source AS 'Source Name'
FROM page_visits;

/*
Query to find pages on CoolTShirts
*/

SELECT DISTINCT page_name AS 'Pages on the CoolTShirts Website'
FROM page_visits;

/*
Query to count first touches per campaign and source
*/

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
    pv.utm_campaign
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp)
SELECT ft_attr.utm_source AS 'Source',
       ft_attr.utm_campaign AS 'Campaign',
       COUNT(*) AS 'Total Count'
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

/*
Query to count last touches per campaign and source
*/

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
    pv.utm_campaign
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp)
SELECT lt_attr.utm_source AS 'Source',
       lt_attr.utm_campaign AS 'Campaign',
       COUNT(*) AS 'Total Count'
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

/*
Query to count how many visitors made purchases
*/

SELECT page_name AS 'Page', COUNT(*) AS 'Total Count'
FROM page_visits
WHERE page_name = '4 - purchase'
GROUP BY 1;

/*
Query to determine how many last touches on the purchase page are each campaign responsible for
*/

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
  	WHERE page_name = '4 - purchase'
    GROUP BY user_id),
lt_attr AS (
SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
    pv.utm_campaign
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp)
SELECT lt_attr.utm_source AS 'Source',
       lt_attr.utm_campaign AS 'Campaign',
       COUNT(*) AS 'Total Count'
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;
