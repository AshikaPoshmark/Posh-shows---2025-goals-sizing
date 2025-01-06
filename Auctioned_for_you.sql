

-----------  - Total user counts with my size set present (across categories) -----------------------

SELECT
    COUNT( DISTINCT user_id) AS total_users_with_Size_set,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Standard%' THEN user_id END ) As Standard_category_total,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Men|Standard%' THEN user_id END ) As men_standard_category,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Women|Standard%' THEN user_id END ) As women_standard_category,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Petite%' THEN user_id END ) As Petite_category,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Juniors%' THEN user_id END ) As Juniors_category,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Plus%' THEN user_id END ) As Plus_category,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Maternity%' THEN user_id END ) As Maternity_category,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Big & Tall%' THEN user_id END ) As Big_Tall_category,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Baby%' THEN user_id END ) As Baby_category,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Girls%' THEN user_id END ) As Girls_category,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Boys%' THEN user_id END ) As Boys_category
 FROM analytics.dw_users
WHERE is_valid_user IS TRUE AND size_set_tags IS NOT NULL AND home_domain = 'us';



----------------------------------- How many are MAU (nov) -------------------------------

SELECT  (TO_CHAR(DATE_TRUNC('month', dw_user_events_daily.event_date ), 'YYYY-MM')) AS event_month,
    COUNT(DISTINCT CASE WHEN ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user ) THEN dw_user_events_daily.user_id END) AS Total_MAU,
        COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Standard%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN dw_user_events_daily.user_id END ) As Standard_category_total,
        COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Men|Standard%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN dw_user_events_daily.user_id END ) As men_standard_category,
        COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Women|Standard%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN dw_user_events_daily.user_id END ) As women_standard_category,
        COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Petite%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN dw_user_events_daily.user_id END ) As Petite_category,
        COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Juniors%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN dw_user_events_daily.user_id END ) As Juniors_category,
        COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Plus%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN dw_user_events_daily.user_id END ) As Plus_category,
        COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Maternity%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN dw_user_events_daily.user_id END ) As Maternity_category,
        COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Big & Tall%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN dw_user_events_daily.user_id END ) As Big_Tall_category,
        COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Baby%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN dw_user_events_daily.user_id END ) As Baby_category,
        COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Girls%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN dw_user_events_daily.user_id END ) As Girls_category,
        COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Boys%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN dw_user_events_daily.user_id END ) As Boys_category

FROM analytics.dw_user_events_daily
INNER JOIN analytics.dw_users ON dw_user_events_daily.user_id = dw_users.user_id
WHERE dw_users.is_valid_user IS TRUE AND size_set_tags IS NOT NULL
  AND (((( dw_user_events_daily.event_date  ) >= ((DATE(DATEADD(month,-5, DATE_TRUNC('month', DATE_TRUNC('day',GETDATE())) ))))
             AND ( dw_user_events_daily.event_date  ) < ((DATE(DATEADD(month,5, DATEADD(month,-5, DATE_TRUNC('month', DATE_TRUNC('day',GETDATE())) ) ))))))
  AND ((coalesce(dw_user_events_daily.app, 'unknown')) in ('unknown','iphone','ipad','external','android','web') )) AND home_domain = 'us'
GROUP BY 1 ORDER BY 1 DESC Limit 10;


-------------  How many of these MAU viewed a show -------------



SELECT (TO_CHAR(DATE_TRUNC('month', dw_user_events_daily.event_date ), 'YYYY-MM')) AS event_month,
    COUNT(DISTINCT CASE WHEN ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user ) THEN  viewer.viewer_id END )As Show_viewer_MAU,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Standard%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN viewer.viewer_id  END ) As Standard_category_total,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Men|Standard%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN viewer.viewer_id  END ) As men_standard_category,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Women|Standard%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN viewer.viewer_id  END ) As women_standard_category,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Petite%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN viewer.viewer_id  END ) As Petite_category,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Juniors%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN viewer.viewer_id  END ) As Juniors_category,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Plus%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN viewer.viewer_id  END ) As Plus_category,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Maternity%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN viewer.viewer_id  END ) As Maternity_category,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Big & Tall%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN viewer.viewer_id  END ) As Big_Tall_category,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Baby%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN viewer.viewer_id  END ) As Baby_category,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Girls%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN viewer.viewer_id  END ) As Girls_category,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Boys%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN viewer.viewer_id  END ) As Boys_category

    FROM analytics.dw_user_events_daily
INNER JOIN analytics.dw_users ON dw_user_events_daily.user_id = dw_users.user_id
LEFT JOIN (SELECT DISTINCT viewer_id,count(show_id)
FROM analytics.dw_show_viewer_events_cs WHERE
      (DATE( dw_show_viewer_events_cs.event_at  ) >= '2024-11-01'
             AND DATE( dw_show_viewer_events_cs.event_at  ) < '2024-12-01')
             GROUP BY 1  ) As viewer ON dw_user_events_daily.user_id = viewer.viewer_id

WHERE dw_users.is_valid_user IS TRUE AND size_set_tags IS NOT NULL
  AND ((DATE( dw_user_events_daily.event_date  ) >= '2024-11-01'
             AND DATE( dw_user_events_daily.event_date  ) < '2024-12-01')
  AND ((coalesce(dw_user_events_daily.app, 'unknown')) in ('unknown','iphone','ipad','external','android','web') )) AND home_domain = 'us'
group by 1;



--------------  How many of these MAU buy in shows and PPL shows

SELECT (TO_CHAR(DATE_TRUNC('month', dw_user_events_daily.event_date ), 'YYYY-MM')) AS event_month,
       COUNT(DISTINCT CASE WHEN ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user ) THEN  buyer.buyer_id END )As Show_buyer_MAU,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Standard%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN buyer.buyer_id  END ) As Standard_category_total,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Men|Standard%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN buyer.buyer_id  END ) As men_standard_category,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Women|Standard%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN buyer.buyer_id  END ) As women_standard_category,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Petite%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN buyer.buyer_id  END ) As Petite_category,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Juniors%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN buyer.buyer_id  END ) As Juniors_category,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Plus%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN buyer.buyer_id  END ) As Plus_category,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Maternity%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN buyer.buyer_id  END ) As Maternity_category,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Big & Tall%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN buyer.buyer_id  END ) As Big_Tall_category,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Baby%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN buyer.buyer_id  END ) As Baby_category,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Girls%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN buyer.buyer_id  END ) As Girls_category,
    COUNT( DISTINCT CASE WHEN size_set_tags LIKE '%Boys%' AND ( dw_user_events_daily.is_active  ) AND ( dw_user_events_daily.is_valid_user )  THEN buyer.buyer_id  END ) As Boys_category

    FROM analytics.dw_user_events_daily
INNER JOIN analytics.dw_users ON dw_user_events_daily.user_id = dw_users.user_id
LEFT JOIN (SELECT DISTINCT buyer_id
FROM analytics.dw_order_items WHERE (auction_id IS NOT NULL OR buy_now_session_id IS NOT NULL)
     AND ((( dw_order_items.booked_at_time  ) >= ((DATE(DATEADD(month,-1, DATE_TRUNC('month', DATE_TRUNC('day',GETDATE())) ))))
             AND ( dw_order_items.booked_at_time  ) < ((DATE(DATEADD(month,1, DATEADD(month,-1, DATE_TRUNC('month', DATE_TRUNC('day',GETDATE())) ) ))))))
                              ) As buyer ON dw_user_events_daily.user_id = buyer.buyer_id

WHERE dw_users.is_valid_user IS TRUE AND size_set_tags IS NOT NULL
  AND (((( dw_user_events_daily.event_date  ) >= ((DATE(DATEADD(month,-1, DATE_TRUNC('month', DATE_TRUNC('day',GETDATE())) ))))
             AND ( dw_user_events_daily.event_date  ) < ((DATE(DATEADD(month,1, DATEADD(month,-1, DATE_TRUNC('month', DATE_TRUNC('day',GETDATE())) ) ))))))
  AND ((coalesce(dw_user_events_daily.app, 'unknown')) in ('unknown','iphone','ipad','external','android','web') )) AND home_domain = 'us'
group by 1;




--------2.a Overall category ---------------
-------------------- - How many Auctions happens across categories (nov) -----------------



SELECT (TO_CHAR(DATE_TRUNC('month', dw_auctions_cs.start_at), 'YYYY-MM')) AS auction_month,
COUNT (DISTINCT CASE WHEN size_set IS NOT NULL THEN dw_auctions_cs.auction_id END) as total_auctions_with_sizeset,
COUNT (DISTINCT CASE WHEN  size_set IS NOT NULL AND ((size_set NOT IN ('Custom Size'))  AND ( ( coalesce(department,'Women') ) NOT  IN ('Electronics','Home','Pets'))) THEN dw_auctions_cs.auction_id END) as total_auctions_with_category,

COUNT(DISTINCT CASE WHEN size_set = 'Standard' AND (( coalesce(department,'Women') ) IN ('Women','Men') ) THEN  dw_auctions_cs.auction_id END) as total_standard_category,
COUNT(DISTINCT CASE WHEN size_set = 'Standard' AND (( coalesce(department,'Women') ) = 'Men' ) THEN  dw_auctions_cs.auction_id END) as men_standard_category,
COUNT(DISTINCT CASE WHEN size_set = 'Standard' AND (( coalesce(department,'Women') ) = 'Women' ) THEN  dw_auctions_cs.auction_id END) as women_standard_category,
COUNT(DISTINCT CASE WHEN size_set = 'Petite'   AND   (( coalesce(department,'Women') ) = 'Women' ) THEN  dw_auctions_cs.auction_id END) as Petite_category,
COUNT(DISTINCT CASE WHEN size_set = 'Juniors' AND (( coalesce(department,'Women') ) = 'Women' ) THEN  dw_auctions_cs.auction_id END) as Juniors_category,
COUNT(DISTINCT CASE WHEN size_set = 'Plus' AND (( coalesce(department,'Women') ) = 'Women' ) THEN  dw_auctions_cs.auction_id END) as Plus_category,
COUNT(DISTINCT CASE WHEN size_set = 'Maternity' AND (( coalesce(department,'Women') ) = 'Women' ) THEN  dw_auctions_cs.auction_id END) as Maternity_category,
COUNT(DISTINCT CASE WHEN size_set = 'Big & Tall' AND (( coalesce(department,'Women') ) = 'Men' ) THEN  dw_auctions_cs.auction_id END) as Big_Tall_category,
COUNT(DISTINCT CASE WHEN size_set = 'Baby' AND (( coalesce(department,'Women') ) = 'Kids' ) THEN  dw_auctions_cs.auction_id END) as Baby_category,
COUNT(DISTINCT CASE WHEN size_set = 'Girls' AND (( coalesce(department,'Women') ) = 'Kids' ) THEN  dw_auctions_cs.auction_id END) as Girls_category,
COUNT(DISTINCT CASE WHEN size_set = 'Boys' AND (department = 'Kids' ) THEN  dw_auctions_cs.auction_id END) as Boys_category



FROM analytics.dw_auctions_cs
LEFT JOIN analytics.dw_listings
ON dw_listings.listing_id = dw_auctions_cs.object_id
LEFT JOIN analytics.dw_listing_inventory_size_quantity AS dw_listing_inventory_size_quantity
ON dw_listings.listing_id = dw_listing_inventory_size_quantity.listing_id
LEFT JOIN analytics.dw_shows ON dw_shows.show_id = dw_auctions_cs.show_id
WHERE ((( dw_auctions_cs.start_at  ) >= ((DATE(DATEADD(month,-1, DATE_TRUNC('month', DATE_TRUNC('day',GETDATE())) ))))
             AND ( dw_auctions_cs.start_at  ) < ((DATE(DATEADD(month,1, DATEADD(month,-1, DATE_TRUNC('month', DATE_TRUNC('day',GETDATE())) ) ))))))
  AND  dw_shows.origin_domain = 'us'
GROUP BY 1;



---------------------  - What is the Order Item distribution across categories (with size) ----------------


SELECT (TO_CHAR(DATE_TRUNC('month', dw_order_items.booked_at_time ), 'YYYY-MM')) AS auction_month,
COUNT (DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set IS NOT NULL THEN dw_order_items.order_id||dw_order_items.listing_id  END) as total_auctions_with_sizeset,
COUNT (DISTINCT CASE WHEN  dw_listing_inventory_size_quantity.size_set IS NOT NULL AND ((dw_listing_inventory_size_quantity.size_set NOT IN ('Custom Size'))  AND ( ( coalesce(department,'Women') ) NOT  IN ('Electronics','Home','Pets'))) THEN dw_order_items.order_id||dw_order_items.listing_id END) as total_auctions_with_category,

COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Standard' AND (( coalesce(department,'Women') ) IN ('Women','Men') ) THEN  dw_order_items.order_id||dw_order_items.listing_id END) as total_standard_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Standard' AND (( coalesce(department,'Women') ) = 'Men' ) THEN  dw_order_items.order_id||dw_order_items.listing_id END) as men_standard_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Standard' AND (( coalesce(department,'Women') ) = 'Women' ) THEN dw_order_items.order_id||dw_order_items.listing_id END) as women_standard_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Petite'   AND   (( coalesce(department,'Women') ) = 'Women' ) THEN  dw_order_items.order_id||dw_order_items.listing_id END) as Petite_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Juniors' AND (( coalesce(department,'Women') ) = 'Women' ) THEN  dw_order_items.order_id||dw_order_items.listing_id END) as Juniors_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Plus' AND (( coalesce(department,'Women') ) = 'Women' ) THEN  dw_order_items.order_id||dw_order_items.listing_id END) as Plus_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Maternity' AND (( coalesce(department,'Women') ) = 'Women' ) THEN  dw_order_items.order_id||dw_order_items.listing_id END) as Maternity_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Big & Tall' AND (( coalesce(department,'Women') ) = 'Men' ) THEN  dw_order_items.order_id||dw_order_items.listing_id END) as Big_Tall_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Baby' AND (( coalesce(department,'Women') ) = 'Kids' ) THEN  dw_order_items.order_id||dw_order_items.listing_id END) as Baby_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Girls' AND (( coalesce(department,'Women') ) = 'Kids' ) THEN  dw_order_items.order_id||dw_order_items.listing_id END) as Girls_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Boys' AND (department = 'Kids' ) THEN  dw_order_items.order_id||dw_order_items.listing_id END) as Boys_category



FROM analytics.dw_order_items
LEFT JOIN analytics.dw_listings
ON dw_listings.listing_id = dw_order_items.listing_id
LEFT JOIN analytics.dw_listing_inventory_size_quantity AS dw_listing_inventory_size_quantity
ON dw_listings.listing_id = dw_listing_inventory_size_quantity.listing_id
WHERE (auction_id IS NOT NULL OR buy_now_session_id IS NOT NULL)
    AND ( DATE( dw_order_items.booked_at_time ) >= '2024-11-01'
             AND DATE( dw_order_items.booked_at_time ) < '2024-12-01')
    AND origin_domain = 'us'

GROUP BY 1;



------- How many auctioned listings happens across categories ----------------






SELECT (TO_CHAR(DATE_TRUNC('month', dw_auctions_cs.start_at), 'YYYY-MM')) AS auction_month,
COUNT (DISTINCT CASE WHEN size_set IS NOT NULL THEN dw_auctions_cs.object_id END) as total_auctions_with_sizeset,
COUNT (DISTINCT CASE WHEN  size_set IS NOT NULL AND ((size_set NOT IN ('Custom Size'))  AND (department NOT  IN ('Electronics','Home','Pets'))) THEN dw_auctions_cs.object_id END) as total_auctions_with_category,

COUNT(DISTINCT CASE WHEN size_set = 'Standard' AND (( coalesce(department,'Women') ) IN ('Women','Men') ) THEN  dw_auctions_cs.object_id END) as total_standard_category,
COUNT(DISTINCT CASE WHEN size_set = 'Standard' AND (( coalesce(department,'Women') ) = 'Men' ) THEN  dw_auctions_cs.object_id END) as men_standard_category,
COUNT(DISTINCT CASE WHEN size_set = 'Standard' AND (( coalesce(department,'Women') ) = 'Women' ) THEN  dw_auctions_cs.object_id END) as women_standard_category,
COUNT(DISTINCT CASE WHEN size_set = 'Petite'   AND   (( coalesce(department,'Women') ) = 'Women' ) THEN  dw_auctions_cs.object_id END) as Petite_category,
COUNT(DISTINCT CASE WHEN size_set = 'Juniors' AND (( coalesce(department,'Women') ) = 'Women' ) THEN  dw_auctions_cs.object_id END) as Juniors_category,
COUNT(DISTINCT CASE WHEN size_set = 'Plus' AND (( coalesce(department,'Women') ) = 'Women' ) THEN  dw_auctions_cs.object_id END) as Plus_category,
COUNT(DISTINCT CASE WHEN size_set = 'Maternity' AND (( coalesce(department,'Women') ) = 'Women' ) THEN  dw_auctions_cs.object_id END) as Maternity_category,
COUNT(DISTINCT CASE WHEN size_set = 'Big & Tall' AND (( coalesce(department,'Women') ) = 'Men' ) THEN  dw_auctions_cs.object_id END) as Big_Tall_category,
COUNT(DISTINCT CASE WHEN size_set = 'Baby' AND (( coalesce(department,'Women') ) = 'Kids' ) THEN  dw_auctions_cs.object_id END) as Baby_category,
COUNT(DISTINCT CASE WHEN size_set = 'Girls' AND (( coalesce(department,'Women') ) = 'Kids' ) THEN  dw_auctions_cs.object_id END) as Girls_category,
COUNT(DISTINCT CASE WHEN size_set = 'Boys' AND (department = 'Kids' ) THEN  dw_auctions_cs.object_id END) as Boys_category



FROM analytics.dw_auctions_cs
LEFT JOIN analytics.dw_listings
ON dw_listings.listing_id = dw_auctions_cs.object_id
LEFT JOIN analytics.dw_listing_inventory_size_quantity AS dw_listing_inventory_size_quantity
ON dw_listings.listing_id = dw_listing_inventory_size_quantity.listing_id
LEFT JOIN analytics.dw_shows ON dw_shows.show_id = dw_auctions_cs.show_id
WHERE (( DATE( dw_auctions_cs.start_at  ) >= '2024-11-01'
             AND ( dw_auctions_cs.start_at  ) < '2024-12-01'))
  AND  dw_shows.origin_domain = 'us'
group by 1;


--------------------------------------  2.b.Category Apparel and Shoes -------------------------



-------------------- - How many Auctions happens across categories (nov) -----------------



SELECT (TO_CHAR(DATE_TRUNC('month', dw_auctions_cs.start_at), 'YYYY-MM')) AS auction_month,
       COUNT (DISTINCT  dw_auctions_cs.auction_id ) as total_auctions,
COUNT (DISTINCT CASE WHEN size_set IS NOT NULL THEN dw_auctions_cs.auction_id END) as total_auctions_with_sizeset,
COUNT (DISTINCT CASE WHEN size_set IS NOT NULL AND category_group IN ('Apparel','Shoes') THEN dw_auctions_cs.auction_id END) as total_auctions_with_given_category,
COUNT (DISTINCT CASE WHEN  size_set IS NOT NULL AND ((size_set NOT IN ('Custom Size'))  AND ( ( coalesce(department,'Women') ) NOT  IN ('Electronics','Home','Pets')))  AND category_group IN ('Apparel','Shoes') THEN dw_auctions_cs.auction_id END) as total_auctions_with_category,

COUNT(DISTINCT CASE WHEN size_set = 'Standard' AND (( coalesce(department,'Women') ) IN ('Women','Men') ) AND category_group IN ('Apparel','Shoes') THEN  dw_auctions_cs.auction_id END) as total_standard_category,
COUNT(DISTINCT CASE WHEN size_set = 'Standard' AND (( coalesce(department,'Women') ) = 'Men' ) AND category_group IN ('Apparel','Shoes') THEN  dw_auctions_cs.auction_id END) as men_standard_category,
COUNT(DISTINCT CASE WHEN size_set = 'Standard' AND (( coalesce(department,'Women') ) = 'Women' ) AND category_group IN ('Apparel','Shoes') THEN  dw_auctions_cs.auction_id END) as women_standard_category,
COUNT(DISTINCT CASE WHEN size_set = 'Petite'   AND   (( coalesce(department,'Women') ) = 'Women' ) AND category_group IN ('Apparel','Shoes') THEN  dw_auctions_cs.auction_id END) as Petite_category,
COUNT(DISTINCT CASE WHEN size_set = 'Juniors' AND (( coalesce(department,'Women') ) = 'Women' ) AND category_group IN ('Apparel','Shoes') THEN  dw_auctions_cs.auction_id END) as Juniors_category,
COUNT(DISTINCT CASE WHEN size_set = 'Plus' AND (( coalesce(department,'Women') ) = 'Women' ) AND category_group IN ('Apparel','Shoes') THEN  dw_auctions_cs.auction_id END) as Plus_category,
COUNT(DISTINCT CASE WHEN size_set = 'Maternity' AND (( coalesce(department,'Women') ) = 'Women' ) AND category_group IN ('Apparel','Shoes') THEN  dw_auctions_cs.auction_id END) as Maternity_category,
COUNT(DISTINCT CASE WHEN size_set = 'Big & Tall' AND (( coalesce(department,'Women') ) = 'Men' ) AND category_group IN ('Apparel','Shoes') THEN  dw_auctions_cs.auction_id END) as Big_Tall_category,
COUNT(DISTINCT CASE WHEN size_set = 'Baby' AND (( coalesce(department,'Women') ) = 'Kids' ) AND category_group IN ('Apparel','Shoes') THEN  dw_auctions_cs.auction_id END) as Baby_category,
COUNT(DISTINCT CASE WHEN size_set = 'Girls' AND (( coalesce(department,'Women') ) = 'Kids' ) AND category_group IN ('Apparel','Shoes') THEN  dw_auctions_cs.auction_id END) as Girls_category,
COUNT(DISTINCT CASE WHEN size_set = 'Boys' AND (department = 'Kids' ) AND category_group IN ('Apparel','Shoes') THEN  dw_auctions_cs.auction_id END) as Boys_category



FROM analytics.dw_auctions_cs
LEFT JOIN ( SELECT *,
             CASE WHEN dw_listings.category_v2 in ('Games','Toys') THEN 'Toys & Games'
              WHEN (coalesce(dw_listings.department,'Women')) in ('Home','Pets','Electronics') THEN (coalesce(dw_listings.department,'Women'))
              WHEN dw_listings.category_v2 in ('Accessories','Jewelry') THEN 'Accessories'
              WHEN dw_listings.category_v2 in ('Bags','Shoes') THEN dw_listings.category_v2
              WHEN dw_listings.category_v2 in ('Makeup','Skincare','Hair','Bath & Body','Bath, Skin & Hair','Grooming') THEN 'Beauty & Wellness'
              WHEN (coalesce(dw_listings.department,'Women')) in ('Women','Men','Kids') and coalesce(dw_listings.category_v2,'Other')='Other' THEN 'Other'
          ELSE 'Apparel' END   AS category_group
                   FROM analytics.dw_listings ) As l
ON l.listing_id = dw_auctions_cs.object_id
LEFT JOIN analytics.dw_listing_inventory_size_quantity AS dw_listing_inventory_size_quantity
ON l.listing_id = dw_listing_inventory_size_quantity.listing_id
LEFT JOIN analytics.dw_shows ON dw_shows.show_id = dw_auctions_cs.show_id
WHERE ( DATE( dw_auctions_cs.start_at  ) >= '2024-11-01'
             AND DATE( dw_auctions_cs.start_at  ) < '2024-12-01')
  AND  dw_shows.origin_domain = 'us'
GROUP BY 1;



---------------------  - What is the Order Item distribution across categories (with size) ----------------


SELECT (TO_CHAR(DATE_TRUNC('month', dw_order_items.booked_at_time ), 'YYYY-MM')) AS booked_month,
       COUNT (DISTINCT dw_order_items.order_id||dw_order_items.listing_id  ) as total_order_items,
COUNT (DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set IS NOT NULL THEN dw_order_items.order_id||dw_order_items.listing_id  END) as total_order_items_with_sizeset,
COUNT (DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set IS NOT NULL AND category_group IN ('Apparel','Shoes') THEN dw_order_items.order_id||dw_order_items.listing_id  END) as total_order_items_with_given_category,
COUNT (DISTINCT CASE WHEN  dw_listing_inventory_size_quantity.size_set IS NOT NULL AND ((dw_listing_inventory_size_quantity.size_set NOT IN ('Custom Size'))  AND ( ( coalesce(department,'Women') ) NOT  IN ('Electronics','Home','Pets'))) AND category_group IN ('Apparel','Shoes') THEN dw_order_items.order_id||dw_order_items.listing_id END) as total_order_items_with_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Standard' AND (( coalesce(department,'Women') ) IN ('Women','Men') ) AND category_group IN ('Apparel','Shoes') THEN  dw_order_items.order_id||dw_order_items.listing_id END) as total_standard_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Standard' AND (( coalesce(department,'Women') ) = 'Men' ) AND category_group IN ('Apparel','Shoes') THEN  dw_order_items.order_id||dw_order_items.listing_id END) as men_standard_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Standard' AND (( coalesce(department,'Women') ) = 'Women' ) AND category_group IN ('Apparel','Shoes') THEN dw_order_items.order_id||dw_order_items.listing_id END) as women_standard_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Petite'   AND   (( coalesce(department,'Women') ) = 'Women' ) AND category_group IN ('Apparel','Shoes') THEN  dw_order_items.order_id||dw_order_items.listing_id END) as Petite_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Juniors' AND (( coalesce(department,'Women') ) = 'Women' ) AND category_group IN ('Apparel','Shoes') THEN  dw_order_items.order_id||dw_order_items.listing_id END) as Juniors_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Plus' AND (( coalesce(department,'Women') ) = 'Women' ) AND category_group IN ('Apparel','Shoes') THEN  dw_order_items.order_id||dw_order_items.listing_id END) as Plus_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Maternity' AND (( coalesce(department,'Women') ) = 'Women' ) AND category_group IN ('Apparel','Shoes') THEN  dw_order_items.order_id||dw_order_items.listing_id END) as Maternity_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Big & Tall' AND (( coalesce(department,'Women') ) = 'Men' ) AND category_group IN ('Apparel','Shoes') THEN  dw_order_items.order_id||dw_order_items.listing_id END) as Big_Tall_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Baby' AND (( coalesce(department,'Women') ) = 'Kids' ) AND category_group IN ('Apparel','Shoes') THEN  dw_order_items.order_id||dw_order_items.listing_id END) as Baby_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Girls' AND (( coalesce(department,'Women') ) = 'Kids' ) AND category_group IN ('Apparel','Shoes') THEN  dw_order_items.order_id||dw_order_items.listing_id END) as Girls_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Boys' AND (department = 'Kids' ) AND category_group IN ('Apparel','Shoes') THEN  dw_order_items.order_id||dw_order_items.listing_id END) as Boys_category



FROM analytics.dw_order_items
LEFT JOIN ( SELECT *,
             CASE WHEN dw_listings.category_v2 in ('Games','Toys') THEN 'Toys & Games'
              WHEN (coalesce(dw_listings.department,'Women')) in ('Home','Pets','Electronics') THEN (coalesce(dw_listings.department,'Women'))
              WHEN dw_listings.category_v2 in ('Accessories','Jewelry') THEN 'Accessories'
              WHEN dw_listings.category_v2 in ('Bags','Shoes') THEN dw_listings.category_v2
              WHEN dw_listings.category_v2 in ('Makeup','Skincare','Hair','Bath & Body','Bath, Skin & Hair','Grooming') THEN 'Beauty & Wellness'
              WHEN (coalesce(dw_listings.department,'Women')) in ('Women','Men','Kids') and coalesce(dw_listings.category_v2,'Other')='Other' THEN 'Other'
          ELSE 'Apparel' END   AS category_group
                   FROM analytics.dw_listings ) As l
ON l.listing_id = dw_order_items.listing_id
LEFT JOIN analytics.dw_listing_inventory_size_quantity AS dw_listing_inventory_size_quantity
ON l.listing_id = dw_listing_inventory_size_quantity.listing_id
WHERE (auction_id IS NOT NULL OR buy_now_session_id IS NOT NULL )
    AND ( DATE( dw_order_items.booked_at_time ) >= '2024-11-01'
             AND DATE( dw_order_items.booked_at_time ) < '2024-12-01')
    AND origin_domain = 'us'

GROUP BY 1;



------- How many auctioned listings happens across categories ----------------






SELECT (TO_CHAR(DATE_TRUNC('month', dw_auctions_cs.start_at), 'YYYY-MM')) AS auction_month,
       COUNT (DISTINCT  dw_auctions_cs.object_id ) as total_auctioned_listing,
COUNT (DISTINCT CASE WHEN size_set IS NOT NULL THEN dw_auctions_cs.object_id END) as total_auctioned_listing_with_sizeset,
COUNT (DISTINCT CASE WHEN size_set IS NOT NULL AND category_group IN ('Apparel','Shoes') THEN dw_auctions_cs.object_id END) as total_auctioned_listing_with_given_category,
COUNT (DISTINCT CASE WHEN  size_set IS NOT NULL AND ((size_set NOT IN ('Custom Size'))  AND (department NOT  IN ('Electronics','Home','Pets'))) AND category_group IN ('Apparel','Shoes') THEN dw_auctions_cs.object_id END) as total_auctioned_listing_with_category,

COUNT(DISTINCT CASE WHEN size_set = 'Standard' AND (( coalesce(department,'Women') ) IN ('Women','Men') ) AND category_group IN ('Apparel','Shoes') THEN  dw_auctions_cs.object_id END) as total_standard_category,
COUNT(DISTINCT CASE WHEN size_set = 'Standard' AND (( coalesce(department,'Women') ) = 'Men' ) AND category_group IN ('Apparel','Shoes') THEN  dw_auctions_cs.object_id END) as men_standard_category,
COUNT(DISTINCT CASE WHEN size_set = 'Standard' AND (( coalesce(department,'Women') ) = 'Women' ) AND category_group IN ('Apparel','Shoes') THEN  dw_auctions_cs.object_id END) as women_standard_category,
COUNT(DISTINCT CASE WHEN size_set = 'Petite'   AND   (( coalesce(department,'Women') ) = 'Women' ) AND category_group IN ('Apparel','Shoes') THEN  dw_auctions_cs.object_id END) as Petite_category,
COUNT(DISTINCT CASE WHEN size_set = 'Juniors' AND (( coalesce(department,'Women') ) = 'Women' ) AND category_group IN ('Apparel','Shoes') THEN  dw_auctions_cs.object_id END) as Juniors_category,
COUNT(DISTINCT CASE WHEN size_set = 'Plus' AND (( coalesce(department,'Women') ) = 'Women' ) AND category_group IN ('Apparel','Shoes') THEN  dw_auctions_cs.object_id END) as Plus_category,
COUNT(DISTINCT CASE WHEN size_set = 'Maternity' AND (( coalesce(department,'Women') ) = 'Women' ) AND category_group IN ('Apparel','Shoes') THEN  dw_auctions_cs.object_id END) as Maternity_category,
COUNT(DISTINCT CASE WHEN size_set = 'Big & Tall' AND (( coalesce(department,'Women') ) = 'Men' ) AND category_group IN ('Apparel','Shoes') THEN  dw_auctions_cs.object_id END) as Big_Tall_category,
COUNT(DISTINCT CASE WHEN size_set = 'Baby' AND (( coalesce(department,'Women') ) = 'Kids' ) AND category_group IN ('Apparel','Shoes') THEN  dw_auctions_cs.object_id END) as Baby_category,
COUNT(DISTINCT CASE WHEN size_set = 'Girls' AND (( coalesce(department,'Women') ) = 'Kids' ) AND category_group IN ('Apparel','Shoes') THEN  dw_auctions_cs.object_id END) as Girls_category,
COUNT(DISTINCT CASE WHEN size_set = 'Boys' AND (department = 'Kids' ) AND category_group IN ('Apparel','Shoes') THEN  dw_auctions_cs.object_id END) as Boys_category



FROM analytics.dw_auctions_cs
LEFT JOIN ( SELECT *,
             CASE WHEN dw_listings.category_v2 in ('Games','Toys') THEN 'Toys & Games'
              WHEN (coalesce(dw_listings.department,'Women')) in ('Home','Pets','Electronics') THEN (coalesce(dw_listings.department,'Women'))
              WHEN dw_listings.category_v2 in ('Accessories','Jewelry') THEN 'Accessories'
              WHEN dw_listings.category_v2 in ('Bags','Shoes') THEN dw_listings.category_v2
              WHEN dw_listings.category_v2 in ('Makeup','Skincare','Hair','Bath & Body','Bath, Skin & Hair','Grooming') THEN 'Beauty & Wellness'
              WHEN (coalesce(dw_listings.department,'Women')) in ('Women','Men','Kids') and coalesce(dw_listings.category_v2,'Other')='Other' THEN 'Other'
          ELSE 'Apparel' END   AS category_group
                   FROM analytics.dw_listings ) As l
ON l.listing_id = dw_auctions_cs.object_id
LEFT JOIN analytics.dw_listing_inventory_size_quantity AS dw_listing_inventory_size_quantity
ON l.listing_id = dw_listing_inventory_size_quantity.listing_id
LEFT JOIN analytics.dw_shows ON dw_shows.show_id = dw_auctions_cs.show_id
WHERE ( DATE( dw_auctions_cs.start_at  ) >= '2024-11-01'
             AND DATE( dw_auctions_cs.start_at  ) < '2024-12-01')
  AND  dw_shows.origin_domain = 'us'
group by 1;



----- total order in poshmark platform



----------------- poshmark orders





SELECT (TO_CHAR(DATE_TRUNC('month', dw_order_items.booked_at_time ), 'YYYY-MM')) AS booked_month,
       COUNT (DISTINCT dw_order_items.order_id||dw_order_items.listing_id  ) as total_order_items,
COUNT (DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set IS NOT NULL THEN dw_order_items.order_id||dw_order_items.listing_id  END) as total_order_items_with_sizeset,
COUNT (DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set IS NOT NULL AND category_group IN ('Apparel','Shoes') THEN dw_order_items.order_id||dw_order_items.listing_id  END) as total_order_items_with_given_category,
COUNT (DISTINCT CASE WHEN  dw_listing_inventory_size_quantity.size_set IS NOT NULL AND ((dw_listing_inventory_size_quantity.size_set NOT IN ('Custom Size'))  AND ( ( coalesce(department,'Women') ) NOT  IN ('Electronics','Home','Pets'))) AND category_group IN ('Apparel','Shoes') THEN dw_order_items.order_id||dw_order_items.listing_id END) as total_order_items_with_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Standard' AND (( coalesce(department,'Women') ) IN ('Women','Men') ) AND category_group IN ('Apparel','Shoes') THEN  dw_order_items.order_id||dw_order_items.listing_id END) as total_standard_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Standard' AND (( coalesce(department,'Women') ) = 'Men' ) AND category_group IN ('Apparel','Shoes') THEN  dw_order_items.order_id||dw_order_items.listing_id END) as men_standard_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Standard' AND (( coalesce(department,'Women') ) = 'Women' ) AND category_group IN ('Apparel','Shoes') THEN dw_order_items.order_id||dw_order_items.listing_id END) as women_standard_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Petite'   AND   (( coalesce(department,'Women') ) = 'Women' ) AND category_group IN ('Apparel','Shoes') THEN  dw_order_items.order_id||dw_order_items.listing_id END) as Petite_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Juniors' AND (( coalesce(department,'Women') ) = 'Women' ) AND category_group IN ('Apparel','Shoes') THEN  dw_order_items.order_id||dw_order_items.listing_id END) as Juniors_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Plus' AND (( coalesce(department,'Women') ) = 'Women' ) AND category_group IN ('Apparel','Shoes') THEN  dw_order_items.order_id||dw_order_items.listing_id END) as Plus_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Maternity' AND (( coalesce(department,'Women') ) = 'Women' ) AND category_group IN ('Apparel','Shoes') THEN  dw_order_items.order_id||dw_order_items.listing_id END) as Maternity_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Big & Tall' AND (( coalesce(department,'Women') ) = 'Men' ) AND category_group IN ('Apparel','Shoes') THEN  dw_order_items.order_id||dw_order_items.listing_id END) as Big_Tall_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Baby' AND (( coalesce(department,'Women') ) = 'Kids' ) AND category_group IN ('Apparel','Shoes') THEN  dw_order_items.order_id||dw_order_items.listing_id END) as Baby_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Girls' AND (( coalesce(department,'Women') ) = 'Kids' ) AND category_group IN ('Apparel','Shoes') THEN  dw_order_items.order_id||dw_order_items.listing_id END) as Girls_category,
COUNT(DISTINCT CASE WHEN dw_listing_inventory_size_quantity.size_set = 'Boys' AND (department = 'Kids' ) AND category_group IN ('Apparel','Shoes') THEN  dw_order_items.order_id||dw_order_items.listing_id END) as Boys_category



FROM analytics.dw_order_items
LEFT JOIN ( SELECT *,
             CASE WHEN dw_listings.category_v2 in ('Games','Toys') THEN 'Toys & Games'
              WHEN (coalesce(dw_listings.department,'Women')) in ('Home','Pets','Electronics') THEN (coalesce(dw_listings.department,'Women'))
              WHEN dw_listings.category_v2 in ('Accessories','Jewelry') THEN 'Accessories'
              WHEN dw_listings.category_v2 in ('Bags','Shoes') THEN dw_listings.category_v2
              WHEN dw_listings.category_v2 in ('Makeup','Skincare','Hair','Bath & Body','Bath, Skin & Hair','Grooming') THEN 'Beauty & Wellness'
              WHEN (coalesce(dw_listings.department,'Women')) in ('Women','Men','Kids') and coalesce(dw_listings.category_v2,'Other')='Other' THEN 'Other'
          ELSE 'Apparel' END   AS category_group
                   FROM analytics.dw_listings ) As l
ON l.listing_id = dw_order_items.listing_id
LEFT JOIN analytics.dw_listing_inventory_size_quantity AS dw_listing_inventory_size_quantity
ON l.listing_id = dw_listing_inventory_size_quantity.listing_id
WHERE  ( DATE( dw_order_items.booked_at_time ) >= '2024-11-01'
             AND DATE( dw_order_items.booked_at_time ) < '2024-12-01')
    AND origin_domain = 'us'

GROUP BY 1;


-----------------------  total listing available size






SELECT --(TO_CHAR(DATE_TRUNC('month', dw_listings.first_published_at), 'YYYY-MM')) AS auction_month,
       COUNT (DISTINCT  dw_listings.first_published_at ) as total_auctioned_listing,
COUNT (DISTINCT CASE WHEN size_set IS NOT NULL THEN dw_listings.first_published_at END) as total_auctioned_listing_with_sizeset,
COUNT (DISTINCT CASE WHEN size_set IS NOT NULL AND category_group IN ('Apparel','Shoes') THEN dw_listings.first_published_at END) as total_auctioned_listing_with_given_category,
COUNT (DISTINCT CASE WHEN  size_set IS NOT NULL AND ((size_set NOT IN ('Custom Size'))  AND (dw_listings.department NOT  IN ('Electronics','Home','Pets'))) AND category_group IN ('Apparel','Shoes') THEN dw_listings.first_published_at END) as total_auctioned_listing_with_category,

COUNT(DISTINCT CASE WHEN size_set = 'Standard' AND (( coalesce(dw_listings.department,'Women') ) IN ('Women','Men') ) AND category_group IN ('Apparel','Shoes') THEN  dw_listings.first_published_at END) as total_standard_category,
COUNT(DISTINCT CASE WHEN size_set = 'Standard' AND (( coalesce(dw_listings.department,'Women') ) = 'Men' ) AND category_group IN ('Apparel','Shoes') THEN  dw_listings.first_published_at END) as men_standard_category,
COUNT(DISTINCT CASE WHEN size_set = 'Standard' AND (( coalesce(dw_listings.department,'Women') ) = 'Women' ) AND category_group IN ('Apparel','Shoes') THEN  dw_listings.first_published_at END) as women_standard_category,
COUNT(DISTINCT CASE WHEN size_set = 'Petite'   AND   (( coalesce(dw_listings.department,'Women') ) = 'Women' ) AND category_group IN ('Apparel','Shoes') THEN  dw_listings.first_published_at END) as Petite_category,
COUNT(DISTINCT CASE WHEN size_set = 'Juniors' AND (( coalesce(dw_listings.department,'Women') ) = 'Women' ) AND category_group IN ('Apparel','Shoes') THEN  dw_listings.first_published_at END) as Juniors_category,
COUNT(DISTINCT CASE WHEN size_set = 'Plus' AND (( coalesce(dw_listings.department,'Women') ) = 'Women' ) AND category_group IN ('Apparel','Shoes') THEN  dw_listings.first_published_at END) as Plus_category,
COUNT(DISTINCT CASE WHEN size_set = 'Maternity' AND (( coalesce(dw_listings.department,'Women') ) = 'Women' ) AND category_group IN ('Apparel','Shoes') THEN  dw_listings.first_published_at END) as Maternity_category,
COUNT(DISTINCT CASE WHEN size_set = 'Big & Tall' AND (( coalesce(dw_listings.department,'Women') ) = 'Men' ) AND category_group IN ('Apparel','Shoes') THEN  dw_listings.first_published_at END) as Big_Tall_category,
COUNT(DISTINCT CASE WHEN size_set = 'Baby' AND (( coalesce(dw_listings.department,'Women') ) = 'Kids' ) AND category_group IN ('Apparel','Shoes') THEN  dw_listings.first_published_at END) as Baby_category,
COUNT(DISTINCT CASE WHEN size_set = 'Girls' AND (( coalesce(dw_listings.department,'Women') ) = 'Kids' ) AND category_group IN ('Apparel','Shoes') THEN  dw_listings.first_published_at END) as Girls_category,
COUNT(DISTINCT CASE WHEN size_set = 'Boys' AND (dw_listings.department = 'Kids' ) AND category_group IN ('Apparel','Shoes') THEN  dw_listings.first_published_at END) as Boys_category



FROM analytics.dw_listings
INNER JOIN ( SELECT *,
             CASE WHEN dw_listings.category_v2 in ('Games','Toys') THEN 'Toys & Games'
              WHEN (coalesce(dw_listings.department,'Women')) in ('Home','Pets','Electronics') THEN (coalesce(dw_listings.department,'Women'))
              WHEN dw_listings.category_v2 in ('Accessories','Jewelry') THEN 'Accessories'
              WHEN dw_listings.category_v2 in ('Bags','Shoes') THEN dw_listings.category_v2
              WHEN dw_listings.category_v2 in ('Makeup','Skincare','Hair','Bath & Body','Bath, Skin & Hair','Grooming') THEN 'Beauty & Wellness'
              WHEN (coalesce(dw_listings.department,'Women')) in ('Women','Men','Kids') and coalesce(dw_listings.category_v2,'Other')='Other' THEN 'Other'
          ELSE 'Apparel' END  AS category_group
                   FROM analytics.dw_listings ) As l
ON l.listing_id = dw_listings.listing_id AND l.first_published_at = dw_listings.first_published_at
LEFT JOIN analytics.dw_listing_inventory_size_quantity AS dw_listing_inventory_size_quantity
ON l.listing_id = dw_listing_inventory_size_quantity.listing_id
WHERE (dw_listings.listing_status = 'published'
AND dw_listings.inventory_status = 'available') -- available listings as of yesterday
AND (dw_listings.is_valid_listing = TRUE);
--group by 1;


