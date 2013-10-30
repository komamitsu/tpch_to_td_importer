select
l_orderkey, 
sum(l_extendedprice*(1-l_discount)) as revenue,
o_orderdate, 
o_shippriority
from 
customer c,
orders o,
lineitem l
where 
c_mktsegment = 'BUILDING'
and c_custkey = o_custkey
and l_orderkey = o_orderkey
and o.time < 795193200
and l.time > 795193200
group by 
l_orderkey, 
o_orderdate, 
o_shippriority
order by 
revenue desc, 
o_orderdate
limit 20
