function dn = epoch2dn(epoch)

dn = datenum([1970 1 1 0 0 0]) + epoch/60/60/24;