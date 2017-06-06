function date = UTC_to_date(x)

date = datestr(x/86400 + datenum(1970,1,1));