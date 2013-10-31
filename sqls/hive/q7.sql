select
supp_nation, 
cust_nation, 
l_year, sum(volume) as revenue
from (
    select 
    n1.n_name as supp_nation, 
    n2.n_name as cust_nation, 
    year(from_unixtime(l.time)) as l_year,
    l.l_extendedprice * (1 - l.l_discount) as volume
    from supplier s
    join lineitem l on s.s_suppkey = l.l_suppkey
    join orders o   on o.o_orderkey = l.l_orderkey
    join customer c on c.c_custkey = o.o_custkey
    join nation n1  on s.s_nationkey = n1.n_nationkey
    join nation n2  on c.c_nationkey = n2.n_nationkey
    where 
    (
        (n1.n_name = 'FRANCE' and n2.n_name = 'GERMANY')
        or (n1.n_name = 'GERMANY' and n2.n_name = 'FRANCE')
    )
    and l.time >= 788886000 and l.time <= 851958000
) shipping
group by 
supp_nation, 
cust_nation, 
l_year
order by 
supp_nation, 
cust_nation, 
l_year
