select
100.00 * sum (
    case 
    when p.p_type like 'PROMO%'
    then l.l_extendedprice * (1 - l.l_discount)
    else 0.0
    end
) / sum (l.l_extendedprice * (1 - l.l_discount)) as promo_revenue
from lineitem l
join part p on l.l_partkey = p.p_partkey
where 
l.l_shipdate >= 809881200
and l.l_shipdate < 809881200 + 3600 * 24 * 30

