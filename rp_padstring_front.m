function [str_out] = rp_padstring_front(str_in,len_str)


assert(len_str>=length(str_in),...
    'rp_padstring_front: padded length must be greater or equal to than the length of the input');

string_length = length(str_in);

string_add = repmat(' ',1,len_str - string_length);

str_out = [string_add str_in];