select
  o.o_clerk,
  count(o.o_clerk)
from
  lineitem l
join
  orders o on l.l_suppkey = o.o_orderkey
group by
  o.o_clerk
limit 8
