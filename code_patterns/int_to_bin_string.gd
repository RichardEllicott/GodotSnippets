"""
converting ints to binary strings

todo:add other conversions

"""


static func int_to_bin_string(n: int) -> String:
    """
    int to binary string like "11010110" etc
    165 => "10100101"
    """
    var ret : String = ""
    while n > 0:
        ret = String(n&1) + ret
        n = n>>1
    return ret
    
static func bin_string_to_int(binary_string: String) -> int:
    """
    "10100101" => 165
    """
    var ret = 0
    for i in binary_string.length():
        var pos = binary_string.length() - 1 - i
        match binary_string[pos]:
            '0':
                pass
            '1':
                var e = pow(2,i)
                ret += e
            _:
                assert(false)
    return ret
