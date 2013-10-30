select
l.l_orderkey, 
sum(l.l_extendedprice*(1-l.l_discount)) as revenue,
o.o_orderdate, 
o.o_shippriority
from 
lineitem l
join orders o on l.l_orderkey = o.o_orderkey
join customer c on c.c_custkey = o.o_custkey
where 
c.c_mktsegment = 'BUILDING'
and o.time < 795193200
and l.time > 795193200
group by 
l.l_orderkey, 
o.o_orderdate, 
o.o_shippriority
order by 
revenue desc, 
o_orderdate
limit 20
