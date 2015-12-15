SELECT pr, sa, da, sp, dp, sum(ipkt), sum(ibyt), count(*) FROM flowdata GROUP BY pr, sa, da, sp, dp;
