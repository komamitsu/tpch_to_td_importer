select
  l_shipmode,
  count(1)
from
  lineitem
group by
  l_shipmode
