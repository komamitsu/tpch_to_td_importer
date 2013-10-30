select
n.n_name, 
sum(l.l_extendedprice * (1 - l.l_discount)) as revenue
from lineitem l
join orders   o on l.l_orderkey  = o.o_orderkey
join customer c on c.c_custkey   = o.o_custkey
join supplier s on l.l_suppkey   = s.s_suppkey
join nation   n on s.s_nationkey = n.n_nationkey
join region   r on n.n_regionkey = r.r_regionkey
where 
r.r_name = 'ASIA'
and o.time >= 757350000
and o.time < 757350000 + 3600 * 24 * 365
group by 
n.n_name
order by 
revenue desc
