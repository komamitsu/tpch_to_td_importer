select
  count(1)
from
  lineitem
where
  time >= 912470400 - 3600 * 24 * 30 and
  time < 912470400
