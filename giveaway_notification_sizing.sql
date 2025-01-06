----  1.Send
------------------------  Giveaway notification  Send (out of users who receive show push how many got giveaway push )--------------------


SELECT dw_user_push_metrics.event_date ,
       COUNT( DISTINCT dw_user_push_metrics.user_id) count_posh_show_push_send,
       COUNT( DISTINCT d.user_id) count_giveaway_push_send
    FROM analytics.dw_user_push_metrics
LEFT JOIN (SELECT event_date, user_id
FROM analytics.dw_user_push_metrics as push
WHERE primary_classification = 'Triggered' AND campaign_category ='Posh Shows' AND campaign_type = 'Posh Show Giveaway Start'
AND (event_date between '2024-11-20' AND '2024-12-21')
GROUP BY 1,2) AS d ON d.user_id = dw_user_push_metrics.user_id AND DATE(dw_user_push_metrics.event_date) = DATE(d.event_date)
WHERE primary_classification = 'Social' AND campaign_category ='Posh Shows Buyers'
AND (dw_user_push_metrics.event_date between '2024-11-20' AND '2024-12-21')
GROUP BY 1;

---------- all giveaway push send ------------------

---------- all giveaway push send (click -> participation -> buyers)------------------

    SELECT event_date,
           COUNT( DISTINCT d.user_id) count_users,
           count( DISTINCT participant_id) count_participants,
           count(DISTINCT buyer_id) as count_buyers,
           count(DISTINCT CASE WHEN dw_order_items.giveaway_id IS NULL THEN buyer_id END) AS count_non_0_gmv_buyers,
           count(DISTINCT CASE WHEN dw_order_items.giveaway_id IS NOT NULL THEN buyer_id END) AS count_giveaway_winner_buyers
    FROM analytics.dw_user_push_metrics as d
    LEFT JOIN analytics.dw_giveaway_entries ON d.user_id = participant_id and DATE(d.event_date) = DATE(created_at)
    LEFT JOIN analytics.dw_order_items ON participant_id = buyer_id AND DATE(created_at) = DATE(booked_at_time)
                                              AND (dw_order_items.giveaway_id IS NOT NULL OR dw_order_items.auction_id IS NOT NULL OR dw_order_items.buy_now_session_id IS NOT NULL)
    WHERE primary_classification = 'Triggered' AND campaign_category ='Posh Shows' AND campaign_type = 'Posh Show Giveaway Start'
    AND (event_date between '2024-11-20' AND '2024-12-21') and clicks > 0
    GROUP BY 1;

---------- all giveaway push send (( send -> participation -> buyers)) ------------------

    SELECT event_date,
           COUNT( DISTINCT d.user_id) count_users,
           count( DISTINCT participant_id) count_participants,
           count(DISTINCT buyer_id) as count_buyers,
           count(DISTINCT CASE WHEN dw_order_items.giveaway_id IS NULL THEN buyer_id END) AS count_non_0_gmv_buyers,
           count(DISTINCT CASE WHEN dw_order_items.giveaway_id IS NOT NULL THEN buyer_id END) AS count_giveaway_winner_buyers
    FROM analytics.dw_user_push_metrics as d
    LEFT JOIN analytics.dw_giveaway_entries ON d.user_id = participant_id and DATE(d.event_date) = DATE(created_at)
    LEFT JOIN analytics.dw_order_items ON participant_id = buyer_id AND DATE(created_at) = DATE(booked_at_time)
                                              AND (dw_order_items.giveaway_id IS NOT NULL OR dw_order_items.auction_id IS NOT NULL OR dw_order_items.buy_now_session_id IS NOT NULL)
    WHERE primary_classification = 'Triggered' AND campaign_category ='Posh Shows' AND campaign_type = 'Posh Show Giveaway Start'
    AND (event_date between '2024-11-20' AND '2024-12-21')
    GROUP BY 1;


----2.Click


---------- click on posh show push

SELECT dw_user_push_metrics.event_date ,
       COUNT( DISTINCT dw_user_push_metrics.user_id) count_posh_show_push_send
    FROM analytics.dw_user_push_metrics
WHERE primary_classification = 'Social' AND campaign_category ='Posh Shows Buyers'
AND (dw_user_push_metrics.event_date between '2024-11-20' AND '2024-12-21') AND clicks>0
GROUP BY 1;




------------------------  Giveaway notification  clicks - overall

SELECT event_date, COUNT( DISTINCT d.user_id) count_users
FROM analytics.dw_user_push_metrics as d
WHERE primary_classification = 'Triggered' AND campaign_category ='Posh Shows' AND campaign_type = 'Posh Show Giveaway Start'
AND (event_date between '2024-11-20' AND '2024-12-21') and clicks > 0
GROUP BY 1;

------------------------  Giveaway notification  clicks - out of users who receive show push how many got giveaway push


SELECT dw_user_push_metrics.event_date , COUNT( DISTINCT dw_user_push_metrics.user_id),COUNT( DISTINCT d.user_id)
    FROM analytics.dw_user_push_metrics
INNER JOIN (SELECT event_date, user_id
FROM analytics.dw_user_push_metrics as push
WHERE primary_classification = 'Triggered' AND campaign_category ='Posh Shows' AND campaign_type = 'Posh Show Giveaway Start'
AND (event_date between '2024-11-20' AND '2024-12-21') AND clicks >0
GROUP BY 1,2) AS d ON d.user_id = dw_user_push_metrics.user_id AND DATE(dw_user_push_metrics.event_date) = DATE(d.event_date)
WHERE primary_classification = 'Social' AND campaign_category ='Posh Shows Buyers'
AND (dw_user_push_metrics.event_date between '2024-11-20' AND '2024-12-21')
GROUP BY 1;


------------------ Some conversion rate from giveaway click -> participation -> buyers (show order) via push funnel -------------------

SELECT dw_user_push_metrics.event_date ,
       COUNT( DISTINCT d.user_id) count_giveaway_click_users ,
       COUNT(distinct participant_id) count_participants,
       COUNT(distinct buyer_id ) count_buyers,
       count(DISTINCT CASE WHEN dw_order_items.giveaway_id IS NULL THEN buyer_id END) AS count_non_0_gmv_buyers,
      count(DISTINCT CASE WHEN dw_order_items.giveaway_id IS NOT NULL THEN buyer_id END) AS count_giveaway_winner_buyers
    FROM analytics.dw_user_push_metrics
LEFT JOIN (SELECT event_date,
                  user_id
FROM analytics.dw_user_push_metrics as push
WHERE primary_classification = 'Triggered' AND campaign_category ='Posh Shows' AND campaign_type = 'Posh Show Giveaway Start'
AND (event_date between '2024-11-20' AND '2024-12-21') AND clicks >0
GROUP BY 1,2) AS d ON d.user_id = dw_user_push_metrics.user_id AND DATE(dw_user_push_metrics.event_date) = DATE(d.event_date)
LEFT JOIN analytics.dw_giveaway_entries ON d.user_id = participant_id and DATE(dw_user_push_metrics.event_date) = DATE(created_at)
LEFT JOIN analytics.dw_order_items ON participant_id = buyer_id AND DATE(dw_user_push_metrics.event_date) = DATE(booked_at_time)
                        AND (dw_order_items.giveaway_id IS NOT NULL OR dw_order_items.auction_id IS NOT NULL OR dw_order_items.buy_now_session_id IS NOT NULL)
WHERE primary_classification = 'Social' AND campaign_category ='Posh Shows Buyers'
AND (dw_user_push_metrics.event_date between '2024-11-20' AND '2024-12-21')
GROUP BY 1;





------------------ 3.Some conversion rate from giveaway click -> participation -> buyers (show order) -------------------

--- directly via push ( send -> click -> participation -> buyers)

SELECT dw_user_push_metrics.event_date ,
       COUNT( DISTINCT d.user_id) count_giveaway_click_users ,
       COUNT(distinct participant_id) count_participants,
       COUNT(distinct buyer_id ) count_buyers,
       count(DISTINCT CASE WHEN dw_order_items.giveaway_id IS NULL THEN buyer_id END) AS count_non_0_gmv_buyers,
      count(DISTINCT CASE WHEN dw_order_items.giveaway_id IS NOT NULL THEN buyer_id END) AS count_giveaway_winner_buyers
    FROM analytics.dw_user_push_metrics
LEFT JOIN (SELECT event_date,
                  user_id
FROM analytics.dw_user_push_metrics as push
WHERE primary_classification = 'Triggered' AND campaign_category ='Posh Shows' AND campaign_type = 'Posh Show Giveaway Start'
AND (event_date between '2024-11-20' AND '2024-12-21') AND clicks >0
GROUP BY 1,2) AS d ON d.user_id = dw_user_push_metrics.user_id AND DATE(dw_user_push_metrics.event_date) = DATE(d.event_date)
LEFT JOIN analytics.dw_giveaway_entries ON d.user_id = participant_id and DATE(dw_user_push_metrics.event_date) = DATE(created_at)
LEFT JOIN analytics.dw_order_items ON participant_id = buyer_id AND DATE(dw_user_push_metrics.event_date) = DATE(booked_at_time)
                        AND (dw_order_items.giveaway_id IS NOT NULL OR dw_order_items.auction_id IS NOT NULL OR dw_order_items.buy_now_session_id IS NOT NULL)
WHERE primary_classification = 'Social' AND campaign_category ='Posh Shows Buyers'
AND (dw_user_push_metrics.event_date between '2024-11-20' AND '2024-12-21')
GROUP BY 1;

---------------------- indirect push (send push but participation -> buy  may not be by clicking on push (( send -> participation -> buyers))



SELECT dw_user_push_metrics.event_date ,
       COUNT( DISTINCT d.user_id) count_giveaway_click_users ,
       COUNT(distinct participant_id) count_participants,
       COUNT(distinct buyer_id ) count_buyers,
       count(DISTINCT CASE WHEN dw_order_items.giveaway_id IS NULL THEN buyer_id END) AS count_non_0_gmv_buyers,
      count(DISTINCT CASE WHEN dw_order_items.giveaway_id IS NOT NULL THEN buyer_id END) AS count_giveaway_winner_buyers
    FROM analytics.dw_user_push_metrics
LEFT JOIN (SELECT event_date,
                  user_id
FROM analytics.dw_user_push_metrics as push
WHERE primary_classification = 'Triggered' AND campaign_category ='Posh Shows' AND campaign_type = 'Posh Show Giveaway Start'
AND (event_date between '2024-11-20' AND '2024-12-21')
GROUP BY 1,2) AS d ON d.user_id = dw_user_push_metrics.user_id AND DATE(dw_user_push_metrics.event_date) = DATE(d.event_date)
LEFT JOIN analytics.dw_giveaway_entries ON d.user_id = participant_id and DATE(dw_user_push_metrics.event_date) = DATE(created_at)
LEFT JOIN analytics.dw_order_items ON participant_id = buyer_id AND DATE(dw_user_push_metrics.event_date) = DATE(booked_at_time)
                        AND (dw_order_items.giveaway_id IS NOT NULL OR dw_order_items.auction_id IS NOT NULL OR dw_order_items.buy_now_session_id IS NOT NULL)
WHERE primary_classification = 'Social' AND campaign_category ='Posh Shows Buyers'
AND (dw_user_push_metrics.event_date between '2024-11-20' AND '2024-12-21')
GROUP BY 1;




---- 3.Each campaign type level of Posh Show Notification ------------------

-------------------- a.Like Notification

---- a.1. push received
 
SELECT event_date, COUNT( DISTINCT d.user_id)
FROM analytics.dw_user_push_metrics as d
LEFT JOIN analytics.dw_giveaway_entries ON d.user_id = participant_id and DATE(d.event_date) = DATE(created_at)
LEFT JOIN analytics.dw_order_items ON participant_id = buyer_id AND DATE(created_at) = DATE(booked_at_time)
WHERE primary_classification = 'Social' AND campaign_type ='Posh Shows Liked Item Notification'
AND (d.event_date between '2024-11-20' AND '2024-12-21')
group by 1;

---a.2. push click

SELECT event_date, COUNT( DISTINCT d.user_id)
FROM analytics.dw_user_push_metrics as d
LEFT JOIN analytics.dw_giveaway_entries ON d.user_id = participant_id and DATE(d.event_date) = DATE(created_at)
LEFT JOIN analytics.dw_order_items ON participant_id = buyer_id AND DATE(created_at) = DATE(booked_at_time)
WHERE primary_classification = 'Social' AND campaign_type ='Posh Shows Liked Item Notification'
AND (d.event_date between '2024-11-20' AND '2024-12-21') and clicks >0
group by 1;

    
--- a.3.giveaway push received ---------

SELECT dw_user_push_metrics.event_date ,
       COUNT( DISTINCT dw_user_push_metrics.user_id) count_posh_show_push_send,
       COUNT( DISTINCT d.user_id) count_giveaway_push_send
    FROM analytics.dw_user_push_metrics
LEFT JOIN (SELECT event_date, user_id
FROM analytics.dw_user_push_metrics as push
WHERE primary_classification = 'Triggered' AND campaign_category ='Posh Shows' AND campaign_type = 'Posh Show Giveaway Start'
AND (event_date between '2024-11-20' AND '2024-12-21')
GROUP BY 1,2) AS d ON d.user_id = dw_user_push_metrics.user_id AND DATE(dw_user_push_metrics.event_date) = DATE(d.event_date)
WHERE primary_classification = 'Social' AND campaign_category ='Posh Shows Buyers' AND campaign_type ='Posh Shows Liked Item Notification'
AND (dw_user_push_metrics.event_date between '2024-11-20' AND '2024-12-21')
GROUP BY 1;

--- a.4.giveaway push clicked ---------

SELECT dw_user_push_metrics.event_date ,
       COUNT( DISTINCT dw_user_push_metrics.user_id) count_posh_show_push_send,
       COUNT( DISTINCT d.user_id) count_giveaway_push_send
    FROM analytics.dw_user_push_metrics
LEFT JOIN (SELECT event_date, user_id
FROM analytics.dw_user_push_metrics as push
WHERE primary_classification = 'Triggered' AND campaign_category ='Posh Shows' AND campaign_type = 'Posh Show Giveaway Start'
AND (event_date between '2024-11-20' AND '2024-12-21') AND clicks>0
GROUP BY 1,2) AS d ON d.user_id = dw_user_push_metrics.user_id AND DATE(dw_user_push_metrics.event_date) = DATE(d.event_date)
WHERE primary_classification = 'Social' AND campaign_category ='Posh Shows Buyers' AND campaign_type ='Posh Shows Liked Item Notification'
AND (dw_user_push_metrics.event_date between '2024-11-20' AND '2024-12-21')
GROUP BY 1;





-------------------- b.Follow

---- b.1. push received


SELECT event_date, COUNT( DISTINCT d.user_id)
FROM analytics.dw_user_push_metrics as d
LEFT JOIN analytics.dw_giveaway_entries ON d.user_id = participant_id and DATE(d.event_date) = DATE(created_at)
LEFT JOIN analytics.dw_order_items ON participant_id = buyer_id AND DATE(created_at) = DATE(booked_at_time)
WHERE primary_classification = 'Social' AND campaign_type ='Posh Shows Follower Notification'
AND (d.event_date between '2024-11-20' AND '2024-12-21')
group by 1;

---b.2. push click

SELECT event_date, COUNT( DISTINCT d.user_id)
FROM analytics.dw_user_push_metrics as d
LEFT JOIN analytics.dw_giveaway_entries ON d.user_id = participant_id and DATE(d.event_date) = DATE(created_at)
LEFT JOIN analytics.dw_order_items ON participant_id = buyer_id AND DATE(created_at) = DATE(booked_at_time)
WHERE primary_classification = 'Social' AND campaign_type ='Posh Shows Follower Notification'
AND (d.event_date between '2024-11-20' AND '2024-12-21') and clicks >0
group by 1;


--- b.3.giveaway push received ---------

SELECT dw_user_push_metrics.event_date ,
       COUNT( DISTINCT dw_user_push_metrics.user_id) count_posh_show_push_send,
       COUNT( DISTINCT d.user_id) count_giveaway_push_send
    FROM analytics.dw_user_push_metrics
LEFT JOIN (SELECT event_date, user_id
FROM analytics.dw_user_push_metrics as push
WHERE primary_classification = 'Triggered' AND campaign_category ='Posh Shows' AND campaign_type = 'Posh Show Giveaway Start'
AND (event_date between '2024-11-20' AND '2024-12-21')
GROUP BY 1,2) AS d ON d.user_id = dw_user_push_metrics.user_id AND DATE(dw_user_push_metrics.event_date) = DATE(d.event_date)
WHERE primary_classification = 'Social' AND campaign_category ='Posh Shows Buyers' AND campaign_type ='Posh Shows Follower Notification'
AND (dw_user_push_metrics.event_date between '2024-11-20' AND '2024-12-21')
GROUP BY 1;

--- b.4.giveaway push clicked ---------

SELECT dw_user_push_metrics.event_date ,
       COUNT( DISTINCT dw_user_push_metrics.user_id) count_posh_show_push_send,
       COUNT( DISTINCT d.user_id) count_giveaway_push_send
    FROM analytics.dw_user_push_metrics
LEFT JOIN (SELECT event_date, user_id
FROM analytics.dw_user_push_metrics as push
WHERE primary_classification = 'Triggered' AND campaign_category ='Posh Shows' AND campaign_type = 'Posh Show Giveaway Start'
AND (event_date between '2024-11-20' AND '2024-12-21') AND clicks>0
GROUP BY 1,2) AS d ON d.user_id = dw_user_push_metrics.user_id AND DATE(dw_user_push_metrics.event_date) = DATE(d.event_date)
WHERE primary_classification = 'Social' AND campaign_category ='Posh Shows Buyers' AND campaign_type ='Posh Shows Follower Notification'
AND (dw_user_push_metrics.event_date between '2024-11-20' AND '2024-12-21')
GROUP BY 1;



-------------------- c. Saved Notification

    
    
---- c.1. push received

SELECT event_date, COUNT( DISTINCT d.user_id)
FROM analytics.dw_user_push_metrics as d
LEFT JOIN analytics.dw_giveaway_entries ON d.user_id = participant_id and DATE(d.event_date) = DATE(created_at)
LEFT JOIN analytics.dw_order_items ON participant_id = buyer_id AND DATE(created_at) = DATE(booked_at_time)
WHERE primary_classification = 'Social' AND campaign_type ='Posh Shows Saved Show Notification'
AND (d.event_date between '2024-11-20' AND '2024-12-21')
group by 1;

---c.2. push click

SELECT event_date, COUNT( DISTINCT d.user_id)
FROM analytics.dw_user_push_metrics as d
LEFT JOIN analytics.dw_giveaway_entries ON d.user_id = participant_id and DATE(d.event_date) = DATE(created_at)
LEFT JOIN analytics.dw_order_items ON participant_id = buyer_id AND DATE(created_at) = DATE(booked_at_time)
WHERE primary_classification = 'Social' AND campaign_type ='Posh Shows Saved Show Notification'
AND (d.event_date between '2024-11-20' AND '2024-12-21') and clicks >0
group by 1;

--- c.3.giveaway push received ---------

    SELECT dw_user_push_metrics.event_date ,
           COUNT( DISTINCT dw_user_push_metrics.user_id) count_posh_show_push_send,
           COUNT( DISTINCT d.user_id) count_giveaway_push_send
        FROM analytics.dw_user_push_metrics
    LEFT JOIN (SELECT event_date, user_id
    FROM analytics.dw_user_push_metrics as push
    WHERE primary_classification = 'Triggered' AND campaign_category ='Posh Shows' AND campaign_type = 'Posh Show Giveaway Start'
    AND (event_date between '2024-11-20' AND '2024-12-21')
    GROUP BY 1,2) AS d ON d.user_id = dw_user_push_metrics.user_id AND DATE(dw_user_push_metrics.event_date) = DATE(d.event_date)
    WHERE primary_classification = 'Social' AND campaign_category ='Posh Shows Buyers' AND campaign_type ='Posh Shows Saved Show Notification'
    AND (dw_user_push_metrics.event_date between '2024-11-20' AND '2024-12-21')
    GROUP BY 1;


--- c.4.giveaway push clicked ---------

    SELECT dw_user_push_metrics.event_date ,
           COUNT( DISTINCT dw_user_push_metrics.user_id) count_posh_show_push_send,
           COUNT( DISTINCT d.user_id) count_giveaway_push_send
        FROM analytics.dw_user_push_metrics
    LEFT JOIN (SELECT event_date, user_id
    FROM analytics.dw_user_push_metrics as push
    WHERE primary_classification = 'Triggered' AND campaign_category ='Posh Shows' AND campaign_type = 'Posh Show Giveaway Start'
    AND (event_date between '2024-11-20' AND '2024-12-21') AND clicks>0
    GROUP BY 1,2) AS d ON d.user_id = dw_user_push_metrics.user_id AND DATE(dw_user_push_metrics.event_date) = DATE(d.event_date)
    WHERE primary_classification = 'Social' AND campaign_category ='Posh Shows Buyers' AND campaign_type ='Posh Shows Saved Show Notification'
    AND (dw_user_push_metrics.event_date between '2024-11-20' AND '2024-12-21')
    GROUP BY 1;


-------------------- d. Mentions Notification

---- d.1. push received

SELECT event_date, COUNT( DISTINCT d.user_id)
FROM analytics.dw_user_push_metrics as d
LEFT JOIN analytics.dw_giveaway_entries ON d.user_id = participant_id and DATE(d.event_date) = DATE(created_at)
LEFT JOIN analytics.dw_order_items ON participant_id = buyer_id AND DATE(created_at) = DATE(booked_at_time)
WHERE primary_classification = 'Social' AND campaign_type ='Posh Shows Mention Notification'
AND (d.event_date between '2024-11-20' AND '2024-12-21')
group by 1;

---d.2. push click

SELECT event_date, COUNT( DISTINCT d.user_id)
FROM analytics.dw_user_push_metrics as d
LEFT JOIN analytics.dw_giveaway_entries ON d.user_id = participant_id and DATE(d.event_date) = DATE(created_at)
LEFT JOIN analytics.dw_order_items ON participant_id = buyer_id AND DATE(created_at) = DATE(booked_at_time)
WHERE primary_classification = 'Social' AND campaign_type ='Posh Shows Mention Notification'
AND (d.event_date between '2024-11-20' AND '2024-12-21') and clicks >0
group by 1;

--- d.3.giveaway push received ---------

SELECT dw_user_push_metrics.event_date ,
       COUNT( DISTINCT dw_user_push_metrics.user_id) count_posh_show_push_send,
       COUNT( DISTINCT d.user_id) count_giveaway_push_send
    FROM analytics.dw_user_push_metrics
LEFT JOIN (SELECT event_date, user_id
FROM analytics.dw_user_push_metrics as push
WHERE primary_classification = 'Triggered' AND campaign_category ='Posh Shows' AND campaign_type = 'Posh Show Giveaway Start'
AND (event_date between '2024-11-20' AND '2024-12-21') AND clicks>0
GROUP BY 1,2) AS d ON d.user_id = dw_user_push_metrics.user_id AND DATE(dw_user_push_metrics.event_date) = DATE(d.event_date)
WHERE primary_classification = 'Social' AND campaign_category ='Posh Shows Buyers' AND campaign_type ='Posh Shows Mention Notification'
AND (dw_user_push_metrics.event_date between '2024-11-20' AND '2024-12-21')
GROUP BY 1;

--- d.4.giveaway push clicked ---------

SELECT dw_user_push_metrics.event_date ,
       COUNT( DISTINCT dw_user_push_metrics.user_id) count_posh_show_push_send,
       COUNT( DISTINCT d.user_id) count_giveaway_push_send
    FROM analytics.dw_user_push_metrics
LEFT JOIN (SELECT event_date, user_id
FROM analytics.dw_user_push_metrics as push
WHERE primary_classification = 'Triggered' AND campaign_category ='Posh Shows' AND campaign_type = 'Posh Show Giveaway Start'
AND (event_date between '2024-11-20' AND '2024-12-21')
GROUP BY 1,2) AS d ON d.user_id = dw_user_push_metrics.user_id AND DATE(dw_user_push_metrics.event_date) = DATE(d.event_date)
WHERE primary_classification = 'Social' AND campaign_category ='Posh Shows Buyers' AND campaign_type ='Posh Shows Mention Notification'
AND (dw_user_push_metrics.event_date between '2024-11-20' AND '2024-12-21')
GROUP BY 1;



