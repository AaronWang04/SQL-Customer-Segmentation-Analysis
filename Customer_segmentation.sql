--Customer Segmentation
--Response Rate during the campaign period
select 
case when b.purchase > 500 then 'Y'
else 'N'
end as response,
count(*) as cnt
from dbo.campaign_info as a
left join dbo.acct_perf as b
on a.Account_number=b.Account_number
where a.campaign='SS201601'
and offer ='action'
and b.ME_DT='2022-03-31'
group by case when b.purchase > 500 then 'Y'
else 'N'
end;


-- Response rate for control group
select offer,
sum(case when b.purchase > 500 then 1.0 else 0 end)/count(*) as resp_rate
from dbo.campaign_info as a
left join dbo.acct_perf as b
on a.Account_number=b.Account_number
where a.campaign='SS201601'
and b.ME_DT='2022-03-31'
group by offer;

--Spending changes for action group in short term
select offer, me_dt, count(*) as cnt,
sum(b.purchase) as tot_purchase, sum(b.Balance) as tot_balance
from dbo.campaign_info as a
left join dbo.acct_perf as b
on a.Account_number=b.Account_number
where a.campaign='SS201601'
group by a.offer, b.ME_DT;

--Spending changes for action group in the long term

select * from dbo.email_acct_detail;

select sum(case when segment = 'Mens E-Mail' then 1.0 else 0 end)/count(*) as men_segment,
sum(case when segment = 'Womens E-Mail' then 1.0 else 0 end)/count(*) as women_segment,
sum(case when segment = 'No E-Mail' then 1.0 else 0 end)/count(*) as no_segment
from dbo.email_acct_detail;

select a.segment, count(*) as cnt from dbo.email_acct_detail as a left join dbo.email_performance as b
on a.Customer_ID = b.Customer_ID group by segment;

select * from dbo.email_performance;

select segment, sum(visit*1.0)/count(*) as visit_rate, sum(conversion*1.0)/count(*) as purchase_rate, sum(spend)/count(*)
as total_spend
from dbo.email_performance as a right join dbo.email_acct_detail as b
on a.Customer_ID = b.Customer_ID group by segment;

select a.recency, a.history_segment, a.history, a.mens, a.womens, a.zip_code, a.newbie,
a.channel, a.segment,
count(*) as cnt,
sum(b.visit) as tot_visit,
sum(b.conversion) as tot_conv,
sum(b.spend) as tot_spend 
from dbo.email_acct_detail as a left join dbo.email_performance as b 
on a.Customer_ID = b.Customer_ID
group by a.recency, a.history_segment, a.mens, a.womens, a.zip_code, a.newbie,
a.channel, a.segment

