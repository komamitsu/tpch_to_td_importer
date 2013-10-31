select
100.00 * sum(
    case 
    when p_type like 'PROMO%'
    then l_extendedprice*(1-l_discount)
    else 0
    end
) / sum(l_extendedprice * (1 - l_discount)) as promo_revenue
from 
lineitem, 
part
where 
l_partkey = p_partkey
and l_shipdate >= 809881200
and l_shipdate < 809881200 + 3600 * 24 * 30
