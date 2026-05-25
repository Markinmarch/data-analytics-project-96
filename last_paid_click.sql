SELECT 
    s.visitor_id,
    s.visit_date,
    s.source AS utm_source,
    s.medium AS utm_medium,
    s.campaign AS utm_campaign,
    s.content AS utm_content,
    l.lead_id,
    l.created_at,
    l.amount,
    l.closing_reason,
    l.learning_format,
    l.status_id
FROM sessions s
LEFT JOIN leads l ON s.visitor_id = l.visitor_id
WHERE
	s.medium IN ('cpc', 'cpm', 'cpa', 'youtube', 'cpp', 'tg', 'social')
	AND s.source ILIKE '%vk%' OR s.source ILIKE '%yandex%' 
ORDER by
	l.amount DESC NULLS LAST,
	s.visit_date,
	s.source NULLS LAST,
	s.medium NULLS LAST,
	s.campaign NULLS LAST,
	s.content NULLS LAST;
