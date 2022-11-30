-- Selecting the data to be analising 

select distinct a.*,
      b.shipping_limit_date,
      b.price,
      b.freight_value,
      c.order_status,
      c.order_purchase_timestamp,
      c.order_approved_at,
      c.order_delivered_carrier_date,
      c.order_delivered_customer_date,
      c.order_estimated_delivery_date,
      e.review_score,
      e.review_comment_title,
      e.review_comment_message,
      f.customer_zip_code_prefix,
      f.customer_city,
      f.customer_state,
      g.seller_zip_code_prefix,
      g.seller_city,
      g.seller_state,
      h.payment_sequential,
      h.payment_type,
      h.payment_value,
      timestamp_diff(c.order_approved_at,c.order_purchase_timestamp, day) as Dif_DtPurchase_AprovOrder,
      timestamp_diff(c.order_delivered_carrier_date,c.order_approved_at, day) as Dif_ApvPay_EntTrasnp,
      timestamp_diff(c.order_delivered_customer_date,c.order_delivered_carrier_date, day) as Dif_Deli_Entcli,
      case when c.order_delivered_customer_date < c.order_estimated_delivery_date then 1 else 0 end as Del_Before_Estim,
      case when c.order_delivered_customer_date > c.order_estimated_delivery_date then 1 else 0 end as Del_Delay,
      case when  REGEXP_CONTAINS(upper(e.review_comment_message), r'VENDEDOR') then 1 else 0 end as Flg_Seller,
      case when e.review_score is not null then 1 else 0 end as Qtd_Comments,
      extract(year from c.order_purchase_timestamp) as YearPurchase,
      case when char_length(concat(extract(year from c.order_purchase_timestamp),extract(month from c.order_purchase_timestamp))) <= 5 then
            concat(extract(year from c.order_purchase_timestamp),"0",extract(month from c.order_purchase_timestamp))
            else concat(extract(year from c.order_purchase_timestamp),extract(month from c.order_purchase_timestamp)) end as YearMonthPursage
from MarketPlace.Table_Products a
left join MarketPlace.Table_Order_Items b
on a.product_id = b.product_id
left join MarketPlace.Table_Orders c
on b.order_id = c.order_id
left join MarketPlace.Table_Order_Reviews e
on c.order_id = e.order_id
left join MarketPlace.Table_Customers f
on c.customer_id = f.customer_id
left join MarketPlace.Table_Sellers g
on b.seller_id = g.seller_id
left join MarketPlace.Table_Order_Payments h
on c.order_id = h.order_id
;