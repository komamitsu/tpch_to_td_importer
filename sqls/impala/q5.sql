select
n_name, 
sum(l_extendedprice * (1 - l_discount)) as revenue
from 
customer, 
supplier, 
nation, 
region,
orders o, 
lineitem 
where 
c_custkey = o_custkey
and c_nationkey = s_nationkey
and s_nationkey = n_nationkey
and n_regionkey = r_regionkey
and l_suppkey = s_suppkey
and l_orderkey = o_orderkey
and r_name = 'ASIA'
and o.time >= 757350000
and o.time < 757350000 + 3600 * 24 * 365
group by 
n_name
order by 
revenue desc
