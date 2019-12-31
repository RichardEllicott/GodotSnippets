"""

shuffle an array similar to python's shuffle

shuffle_array(array) # shuffles array different each time using the default RandomNumberGenerator
shuffle_array(array,seed_number) # shuffles with a seed number, 2638, allowing the shuffle to occur the same each time

"""

func shuffle_array(array, _seed = null):
    
    # returns a shuffled copy of an array
    # if _seed is not null
    # will use a seed for procedural results
    
    array = array.duplicate()
    var rand_gen
    if _seed != null:
        rand_gen = RandomNumberGenerator.new()
        rand_gen.set_seed(_seed)
    var shuffledList = []
    var indexList = range(array.size())
    var ran_i

    for i in range(array.size()):
        if _seed == null: # if no seed was provided use default random
            ran_i = randi()
        else:
            ran_i = rand_gen.randi()

        var array_pos = ran_i % indexList.size()
        shuffledList.append(array[array_pos])
        indexList.remove(array_pos)
        array.remove(array_pos)

    return shuffledList