"""

convert a csv string to table



"""



func csv_string_to_table(_string, delimiter = ','):

    var ret = []

    for line in _string.split('\n'):
        var row = []
        for val in line.split(delimiter):
            if val.is_valid_integer():
                val = int(val)
            elif val.is_valid_float():
                val = float(val)
            row.append(val)
        ret.append(row)

    return ret

