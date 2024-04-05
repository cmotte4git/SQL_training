WITH 
  sales_by_month_by_id as
  (
  select 
  property_id, 
  month(purchased_date) mon,
  count(*) as count_rentals,
  strftime(purchased_date,  '%Y-%b') AS mon_yr
  from airbnb_fct_rentals
  group by all
  ) ,
    sales_lag_by_id as 
      (
      select 
      property_id,
      mon,
      mon_yr,
      count_rentals as curr_month,
      coalesce(lag(count_rentals) over (partition by property_id order by mon asc),0) as prior_month
      from sales_by_month_by_id
      )

SELECT 
  property_id,  mon_yr, prior_month,
  curr_month,
  round((curr_month - prior_month)/prior_month*100,2) as delta_chg
  FROM sales_lag_by_id
  where prior_month <> 0
Order by delta_chg desc, property_id asc
limit 5


