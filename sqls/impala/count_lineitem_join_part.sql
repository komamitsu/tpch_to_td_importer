select
  p.p_name,
  count(p.p_name)
from
  lineitem l
join
  part p on l.l_suppkey = p.p_partkey
group by
  p.p_name
limit 8
