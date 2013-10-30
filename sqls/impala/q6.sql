select
sum(l_extendedprice*l_discount) as revenue
from 
lineitem
where 
time >= 757350000
and time < 757350000 + 3600 * 24 * 365
and l_discount between 0.06 - 0.01 and 0.06 + 0.01
and l_quantity < 24
