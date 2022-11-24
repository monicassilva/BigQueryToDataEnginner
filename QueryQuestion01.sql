-- subquery to extract the metrics

select  product_category_name,
                YearPurchase, 
                count(*) as QuantityPerCategory,
                round(sum(price),2) as TotalPurchasePerCategory,
                round((select sum(price) from MarketPlace.Table_Order_Items),2)as  TotalPurchase,
                (sum(price) / (select sum(price)from MarketPlace.Table_Order_Items )) as AvgTicket,
                (select count(*) from MarketPlace.Table_Order_Reviews) as QTDTotalPurchage

from (

-- extract the datas to be use
select  a.product_id, 
        a.product_category_name,
        b.order_item_id,
        b.price,
        c.order_status,
        extract(year from c.order_purchase_timestamp) as YearPurchase,
        d.payment_type,
        e.review_score
    from `MarketPlace.Table_Products` a 
left join `MarketPlace.Table_Order_Items` b
on a.product_id = b.product_id

left join `MarketPlace.Table_Orders` c
on b.order_id = c.order_id

left join `MarketPlace.Table_Order_Payments` d
on c.order_id = d.order_id

left join `MarketPlace.Table_Order_Reviews` e
on d.order_id = e.order_id 

)
group by 1,2
order by QuantityPerCategory desc
LIMIT 12
;