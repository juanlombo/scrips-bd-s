sed -n '/2025-05-29/,/2025-05-30/p' alert_wmscdb1.log > alert_20250529.log

sed -n '/2025-05-29T/,/2025-05-30T/p' alert_wmscdb1.log > alert_20250529.log


awk '$0 >= "2025-05-29T00:00:00" && $0 < "2025-05-30T00:00:00"' alert_wmscdb1.log > alert_20250529_wmscdb1.log
