

----------------------------------------------- 1.Frequent Giveaway Participants------------------------------

 ----------------------------   Entered 1+ Giveaway Daily -----------------

SELECT t.start_date,count(t.participant_id) FROM (SELECT DATE(start_at) as start_date,participant_id,count(dw_giveaway_entries.giveaway_id) FROM analytics.dw_giveaway_entries
LEFT JOIN analytics.dw_giveaways ON dw_giveaways.giveaway_id = dw_giveaway_entries.giveaway_id
GROUP BY 1,2 having count(dw_giveaway_entries.giveaway_id) > 1 ) as t group by 1 ;

---------- overall level ---------------------

SELECT count( distinct t.participant_id) FROM (SELECT DATE(start_at) as start_date,participant_id,count(dw_giveaway_entries.giveaway_id) FROM analytics.dw_giveaway_entries
LEFT JOIN analytics.dw_giveaways ON dw_giveaways.giveaway_id = dw_giveaway_entries.giveaway_id
GROUP BY 1,2 having count(dw_giveaway_entries.giveaway_id) > 1 ) as t  ;

-----------------------   Won a Giveaway in the last 14 days -----------

---- way 1 -----------
SELECT start_date, count(distinct d.winner_participant_id) FROM (SELECT start_date, t.participant_id,winner_participant_id,DATE(dw_giveaways.start_at) As giveaway_winner_date FROM
(SELECT DATE(start_at) as start_date, DATE(dateadd( day, -14, DATE(start_at))) as D_last_14, participant_id FROM analytics.dw_giveaway_entries
LEFT JOIN analytics.dw_giveaways ON dw_giveaways.giveaway_id = dw_giveaway_entries.giveaway_id) as t
LEFT JOIN analytics.dw_giveaways ON t.participant_id = winner_participant_id
WHERE giveaway_winner_date >= D_last_14 AND giveaway_winner_date < start_date) as d
group by 1;


-------- way 2 -----------

SELECT start_date, count( distinct winner_participant_id) FROM
(SELECT DATE(start_at) as start_date, DATE(dateadd( day, -14, DATE(start_at))) as D_last_14, participant_id FROM analytics.dw_giveaway_entries
LEFT JOIN analytics.dw_giveaways ON dw_giveaways.giveaway_id = dw_giveaway_entries.giveaway_id) as t
INNER JOIN analytics.dw_giveaways ON t.participant_id = winner_participant_id AND  DATE(dw_giveaways.start_at) >= D_last_14 AND DATE(dw_giveaways.start_at) < start_date
group by 1;


--------------------------------------------- 2.Users that have never received a giveaway push and… Past Show Buyers and engaged viewer ---------------------

----------------- ---- way 1 buyer_activated_engaged_viewer_with_no_push -------------------

SELECT count( distinct viewer_id) FROM (SELECT  distinct viewer_id,show_buyer_activated_at,
    dw_user_push_metrics.user_id from analytics.dw_show_viewer_events_cs
LEFT JOIN analytics.dw_users_cs ON dw_users_cs.user_id = dw_show_viewer_events_cs.viewer_id
LEFT JOIN analytics.dw_users ON dw_users.user_id = dw_show_viewer_events_cs.viewer_id
LEFT JOIN analytics.dw_user_push_metrics ON dw_user_push_metrics.user_id = dw_show_viewer_events_cs.viewer_id AND campaign_type = 'Posh Show Giveaway Start'
WHERE dw_show_viewer_events_cs.viewer_id != dw_show_viewer_events_cs.host_id
    and (host_follow_clicks > 0
    OR sent_show_comments_clicks > 0
    OR sent_show_reactions_clicks > 0
    OR show_listing_likes_clicks > 0
    OR show_bid_clicks > 0
    OR show_listing_detail_clicks > 0
    OR show_host_closet_clicks > 0
    OR total_watched_show_minutes >= 1) AND show_buyer_activated_at IS NOT NULL and home_domain ='us' and is_valid_user IS TRUE) as t
WHERE user_id is null ;

--------- way-2.a. Overall values AND Non-Buyer Activated Engaged Viewers --------------------

SELECT count( distinct viewer_id) as total_viewers,
       count( distinct case when show_buyer_activated_at is not null then viewer_id else null end) as buyer_activated_viewers,
       count( distinct  engaged_viewer) total_engaged_viewer,
       count( distinct case when show_buyer_activated_at is not null then engaged_viewer else null end) as buyer_activated_engaged_viewer,
       count( distinct case when show_buyer_activated_at is null then engaged_viewer else null end) as non_buyer_activated_engaged_viewer,
       count (distinct user_id ) as push_received_viewers,
       count( distinct case when engaged_viewer is not null then user_id else null end) as push_received_engaged_viewer,
       count( distinct case when show_buyer_activated_at is not null and user_id is null then viewer_id else null end) as buyer_activated_viewers_with_no_push,
       count( distinct case when show_buyer_activated_at is not null and user_id is null then engaged_viewer else null end) as buyer_activated_engaged_viewer_with_no_push,
       count( distinct case when show_buyer_activated_at is null and user_id is null then engaged_viewer else null end) as non_buyer_activated_engaged_viewer_with_no_push


        FROM (SELECT  distinct viewer_id, engaged_viewer, show_buyer_activated_at,
    dw_user_push_metrics.user_id from analytics.dw_show_viewer_events_cs

LEFT JOIN analytics.dw_users_cs ON dw_users_cs.user_id = dw_show_viewer_events_cs.viewer_id

LEFT JOIN (select distinct viewer_id as engaged_viewer FROM analytics.dw_show_viewer_events_cs
            WHERE dw_show_viewer_events_cs.viewer_id != dw_show_viewer_events_cs.host_id
    and (host_follow_clicks > 0
    OR sent_show_comments_clicks > 0
    OR sent_show_reactions_clicks > 0
    OR show_listing_likes_clicks > 0
    OR show_bid_clicks > 0
    OR show_listing_detail_clicks > 0
    OR show_host_closet_clicks > 0
    OR total_watched_show_minutes >= 1)) As d ON d.engaged_viewer = dw_show_viewer_events_cs.viewer_id

LEFT JOIN analytics.dw_user_push_metrics ON dw_user_push_metrics.user_id = dw_show_viewer_events_cs.viewer_id AND campaign_type = 'Posh Show Giveaway Start'
LEFT JOIN analytics.dw_users ON viewer_id = dw_users.user_id
WHERE home_domain = 'us' AND is_valid_user is TRUE ) as t;

--------------------- way-2.b. For the Month November ---------------------

SELECT count( distinct viewer_id) as total_viewers,
       count( distinct case when show_buyer_activated_at is not null then viewer_id else null end) as buyer_activated_viewers,
       count( distinct  engaged_viewer) total_engaged_viewer,
       count( distinct case when show_buyer_activated_at is not null then engaged_viewer else null end) as buyer_activated_engaged_viewer,
       count( distinct case when show_buyer_activated_at is null then engaged_viewer else null end) as non_buyer_activated_engaged_viewer,
       count (distinct user_id ) as push_received_viewers,
       count( distinct case when engaged_viewer is not null then user_id else null end) as push_received_engaged_viewer,
       count( distinct case when show_buyer_activated_at is not null and user_id is null then viewer_id else null end) as buyer_activated_viewers_with_no_push,
       count( distinct case when show_buyer_activated_at is not null and user_id is null then engaged_viewer else null end) as buyer_activated_engaged_viewer_with_no_push,
       count( distinct case when show_buyer_activated_at is null and user_id is null then engaged_viewer else null end) as non_buyer_activated_engaged_viewer_with_no_push


        FROM (SELECT  distinct viewer_id, engaged_viewer, show_buyer_activated_at,
    dw_user_push_metrics.user_id from analytics.dw_show_viewer_events_cs

LEFT JOIN analytics.dw_users_cs ON dw_users_cs.user_id = dw_show_viewer_events_cs.viewer_id

LEFT JOIN (select distinct viewer_id as engaged_viewer FROM analytics.dw_show_viewer_events_cs
            WHERE dw_show_viewer_events_cs.viewer_id != dw_show_viewer_events_cs.host_id
    and (host_follow_clicks > 0
    OR sent_show_comments_clicks > 0
    OR sent_show_reactions_clicks > 0
    OR show_listing_likes_clicks > 0
    OR show_bid_clicks > 0
    OR show_listing_detail_clicks > 0
    OR show_host_closet_clicks > 0
    OR total_watched_show_minutes >= 1) AND (DATE(event_at) >= '2024-11-01' AND DATE(event_at) < '2024-12-01') ) As d ON d.engaged_viewer = dw_show_viewer_events_cs.viewer_id

LEFT JOIN analytics.dw_user_push_metrics ON dw_user_push_metrics.user_id = dw_show_viewer_events_cs.viewer_id AND campaign_type = 'Posh Show Giveaway Start'
LEFT JOIN analytics.dw_users ON viewer_id = dw_users.user_id
WHERE home_domain = 'us' AND is_valid_user is TRUE AND (DATE(event_at) >= '2024-11-01' AND DATE(event_at) < '2024-12-01')  ) as t;



------------------ 3. Show Non Engaged Viewers who have never received a Giveaway Push but viewed (1,3+,5+ shows) a show in the last 30 days -------------------------------------




SELECT count(distinct viewer_id) as total_unique_viewer,
       count(distinct CASE WHEN count_engaged_shows > 0 THEN viewer_id END) as engaged_viewer,
       count(distinct CASE WHEN count_engaged_shows > 0 AND user_id is NULL  THEN viewer_id END) as engaged_viewer_with_no_push,
       count(distinct CASE WHEN count_engaged_shows = 0 THEN viewer_id END) as non_engaged_viewer,
       count(distinct CASE WHEN count_engaged_shows = 0 AND user_id is NULL THEN viewer_id END) as non_engaged_viewer_with_no_push,
       count(distinct CASE WHEN count_engaged_shows = 0 AND count_viewed_shows >= 5 THEN viewer_id END) as non_engaged_viewer_with_more_then_5_show_view,
       count(distinct CASE WHEN count_engaged_shows = 0 AND count_viewed_shows >=5 AND user_id is NULL THEN viewer_id END) as non_engaged_viewer_with_more_then_5_show_view_with_no_push_notifi,
       count(distinct CASE WHEN count_engaged_shows = 0 AND count_viewed_shows > 2 THEN viewer_id END) as non_engaged_viewer_with_more_then_3_show_view,
       count(distinct CASE WHEN count_engaged_shows = 0 AND count_viewed_shows > 2 AND user_id is NULL THEN viewer_id END) as non_engaged_viewer_with_more_then_3_show_view_with_no_push_notifi
       FROM (SELECT viewer_id,
       count( distinct show_id),
       COUNT( distinct case when dw_show_viewer_events_cs.viewer_id != dw_show_viewer_events_cs.host_id
    and (host_follow_clicks > 0
    OR sent_show_comments_clicks > 0
    OR sent_show_reactions_clicks > 0
    OR show_listing_likes_clicks > 0
    OR show_bid_clicks > 0
    OR show_listing_detail_clicks > 0
    OR show_host_closet_clicks > 0
    OR total_watched_show_minutes >= 1) THEN show_id END ) as count_engaged_shows,
           COUNT( distinct case when dw_show_viewer_events_cs.viewer_id != dw_show_viewer_events_cs.host_id
    and NOT (host_follow_clicks > 0
    OR sent_show_comments_clicks > 0
    OR sent_show_reactions_clicks > 0
    OR show_listing_likes_clicks > 0
    OR show_bid_clicks > 0
    OR show_listing_detail_clicks > 0
    OR show_host_closet_clicks > 0
    OR total_watched_show_minutes >= 1) THEN show_id END ) as count_viewed_shows

from analytics.dw_show_viewer_events_cs
   LEFT JOIN analytics.dw_users ON user_id = viewer_id
WHERE date(event_at) >= '2024-12-01' AND date(event_at) < '2024-12-31' AND home_domain ='us' AND is_valid_user = TRUE
group by  1 ) as d
LEFT JOIN (SELECT distinct user_id FROM analytics.dw_user_push_metrics WHERE campaign_type = 'Posh Show Giveaway Start' AND date(event_date) < '2024-12-31' ) as f ON viewer_id=user_id ;



------------------------  4.Non-Show Viewers ------------------------------

-----------------  4.a.Viewer Activated but have not watched a Show in the last 30+ days: -----------------------
--- way 1 -------
SELECT count(distinct viewer_id),
       count(distinct case when show_viewer_activated_at is not null  then viewer_id end) as count_viers,
       count(distinct case when show_viewer_activated_at is not null and last_viewed_at < '2024-12-01' then viewer_id end) as count_viers FROM
       (SELECT viewer_id,show_viewer_activated_at, MAX(event_at) as last_viewed_at FROM analytics.dw_show_viewer_events_cs
LEFT JOIN analytics.dw_users ON user_id = viewer_id
LEFT JOIN analytics.dw_users_cs ON viewer_id = dw_users_cs.user_id

WHERE home_domain ='us' AND is_valid_user IS TRUE
GROUP BY 1 ,2 ) as t;

---- way 2 -----------
SELECT count(distinct user_id),
       count(distinct case when show_viewer_activated_at is not null and last_viewed_at < '2024-11-30' then user_id end) as count_viers
       FROM (SELECT dw_users_cs.user_id,show_viewer_activated_at, MAX(event_at) as last_viewed_at FROM analytics.dw_users_cs
LEFT JOIN analytics.dw_users ON dw_users_cs.user_id = dw_users.user_id
LEFT JOIN analytics.dw_show_viewer_events_cs ON viewer_id = dw_users_cs.user_id

WHERE home_domain ='us' AND is_valid_user IS TRUE AND show_viewer_activated_at IS NOT NULL
GROUP BY 1 ,2) as g;


--------------  5.Non-Viewer Activated but Poshmark Buyer Activated --------------

----5.a.Overall timeline ----

SELECT count(dw_users.user_id) as count_total_poshmark_users,
       count(DISTINCT CASE WHEN  buyer_activated_at IS NOT NULL THEN dw_users.user_id END ) AS poshmark_user_buyers,
       count(DISTINCT CASE WHEN  buyer_activated_at IS NOT NULL AND show_viewer_activated_at IS NOT NULL THEN dw_users.user_id END ) AS poshmark_show_viewer_buyers,
       count(DISTINCT CASE WHEN  show_viewer_activated_at IS NULL AND buyer_activated_at IS NOT NULL THEN dw_users.user_id END ) AS count_non_viewer_activated_poshmark_buyer
       FROM analytics.dw_users
LEFT JOIN analytics.dw_users_cs ON dw_users_cs.user_id = dw_users.user_id

WHERE home_domain ='us' AND is_valid_user IS TRUE  ;

---------------5.b. Year 2024 ----------------------

SELECT count(dw_users.user_id) as count_total_poshmark_users,
       count(DISTINCT CASE WHEN  buyer_activated_at IS NOT NULL THEN dw_users.user_id END ) AS poshmark_user_buyers,
       count(DISTINCT CASE WHEN  buyer_activated_at IS NOT NULL AND show_viewer_activated_at IS NOT NULL THEN dw_users.user_id END ) AS poshmark_show_viewer_buyers,
       count(DISTINCT CASE WHEN  show_viewer_activated_at IS NULL AND buyer_activated_at IS NOT NULL THEN dw_users.user_id END ) AS count_non_viewer_activated_poshmark_buyer
       FROM analytics.dw_users
LEFT JOIN analytics.dw_users_cs ON dw_users_cs.user_id = dw_users.user_id

WHERE home_domain ='us' AND is_valid_user IS TRUE AND (DATE(buyer_activated_at) >= '2024-01-01'  AND DATE(buyer_activated_at) < '2025-01-01') ;


----------- 5.c.Month Nov 2024 -----------------------

SELECT count(dw_users.user_id) as count_total_poshmark_users,
       count(DISTINCT CASE WHEN  buyer_activated_at IS NOT NULL THEN dw_users.user_id END ) AS poshmark_user_buyers,
       count(DISTINCT CASE WHEN  buyer_activated_at IS NOT NULL AND show_viewer_activated_at IS NOT NULL THEN dw_users.user_id END ) AS poshmark_show_viewer_buyers,
       count(DISTINCT CASE WHEN  show_viewer_activated_at IS NULL AND buyer_activated_at IS NOT NULL THEN dw_users.user_id END ) AS count_non_viewer_activated_poshmark_buyer
       FROM analytics.dw_users
LEFT JOIN analytics.dw_users_cs ON dw_users_cs.user_id = dw_users.user_id

WHERE home_domain ='us' AND is_valid_user IS TRUE AND (DATE(buyer_activated_at) >= '2024-11-01'  AND DATE(buyer_activated_at) < '2024-12-01') ;


