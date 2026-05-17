SELECT 
    s.visit_date::DATE AS visit_date,
    s.source AS utm_source,
    s.medium AS utm_medium,
    s.campaign AS utm_campaign,
    COUNT(DISTINCT s.visitor_id) AS visitors_count,
    COALESCE(SUM(a.daily_spent), 0) AS total_cost,
    COUNT(DISTINCT l.lead_id) AS leads_count,
    COUNT(DISTINCT CASE WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142 THEN l.lead_id END) AS purchases_count,
    COALESCE(SUM(CASE WHEN l.closing_reason = 'Успешно реализовано' OR l.status_id = 142 THEN l.amount END), 0) AS revenue
FROM sessions s
LEFT JOIN leads l 
    ON s.visitor_id = l.visitor_id 
    AND l.created_at >= s.visit_date
LEFT JOIN (
    SELECT campaign_date, utm_source, utm_medium, utm_campaign, utm_content, daily_spent FROM vk_ads
    UNION ALL
    SELECT campaign_date, utm_source, utm_medium, utm_campaign, utm_content, daily_spent FROM ya_ads
) a 
    ON s.visit_date::DATE = a.campaign_date
    AND s.source = a.utm_source
    AND s.medium = a.utm_medium
    AND s.campaign = a.utm_campaign
    AND s.content = a.utm_content
WHERE s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
GROUP BY 
    s.visit_date::DATE,
    s.source,
    s.medium,
    s.campaign
ORDER BY 
    revenue DESC NULLS LAST,
    visit_date ASC,
    visitors_count DESC,
    utm_source ASC NULLS FIRST,
    utm_medium ASC NULLS FIRST,
    utm_campaign ASC NULLS first
LIMIT 15;
