"""

a random bag is used for creating weighted random results

input an array, for example [10,40,30,20] (adds up to 100)

would return:
0 10% of the time
1 40% of the time
2 30% of the time
3 20% of the time


you are not required to add the points up to 100, you could equally use [1,2,3] for example:

0: 20%
1: 40%
2: 60%


random bag is useful for things like random drops or events where more rare events must occur less often


"""


func random_bag(ran_bag_list_lists = null, _randf = rand()):
    """
    input a list of weights like:

        [25,30,20,25]

    return a random index

    """

    var sum_of_weight = 0.0

    for weight in ran_bag_list_lists:
        sum_of_weight += weight

    var ranf = _randf * sum_of_weight

    for i in ran_bag_list_lists.size():
        var weight = ran_bag_list_lists[i]

        if ranf < weight:
            return i
        ranf -= weight

    assert(false) # should never reach here


export var ran_seed = 0




func prove_the_random_bag_function():


    var ran_bag_list_lists = [25,30,20,25]


    var prove_rand_bag = {} # count the results

    var test_cycles = 10000 # times to test

    print("test %s times..." % test_cycles)

    for i in test_cycles:

        var result2 = random_bag(ran_bag_list_lists, i)

        if not result2 in prove_rand_bag:
            prove_rand_bag[result2] = 0

        prove_rand_bag[result2] += 1


    print("test results: ", prove_rand_bag)

    for key in prove_rand_bag:
        var entry = prove_rand_bag[key] / float(test_cycles) * 100.0 # convert to a percentage
        print("%s %s" % [key, entry])


    """

    test 10000 times...
    test results: {0:2484, 1:3009, 2:1988, 3:2519}
    0 24.84
    1 30.09
    2 19.88
    3 25.19

    """



