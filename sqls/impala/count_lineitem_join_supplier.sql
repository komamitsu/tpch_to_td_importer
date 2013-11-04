select
  s.s_name,
  count(s.s_name)
from
  lineitem l
join
  supplier s on l.l_suppkey = s.s_suppkey
group by
  s.s_name
limit 8
