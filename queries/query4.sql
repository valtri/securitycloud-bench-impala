SELECT sa, sum(ipkt), sum(ibyt) as bytes, count(*) FROM flowdata WHERE pr = "TCP" GROUP BY sa ORDER BY bytes;
