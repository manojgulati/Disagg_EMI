function date = UTC_to_IST(x)

date = datestr((x+19800)/86400+ datenum(1970,1,1),13);


% Last parameter specifies the output date format
% Link for reference:
% http://in.mathworks.com/help/matlab/ref/datestr.html#inputarg_formatOut