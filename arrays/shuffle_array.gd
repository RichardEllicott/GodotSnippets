"""

shuffle an array similar to python's shuffle


there is already a built in shuffle in Godot, but I've kept this for seeded shuffles

this function does not affect the seed of the RandomNumberGenerator as it creates it's own one

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

    var shuffled_array = [] # return this
    shuffled_array.resize(array.size()) # allocate correct length

    var ran_i # random integer

    for i in range(array.size()):
        if _seed == null: # if no seed was provided use default random
            ran_i = randi()
        else:
            ran_i = rand_gen.randi()

        var array_pos = ran_i % array.size()

        shuffled_array[i] = array[array_pos]

        array.remove(array_pos) # a bit slower maybe

    return shuffled_array