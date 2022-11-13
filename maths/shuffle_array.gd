"""

shuffle an array, optional seed

seed is useful to shuffle a deck of cards the same way for instance



note 0 doesn't seem to work as seed, really this should have an option of entering an RNG object it's flawed as it changes global seed


"""


func shuffle_array(list, _seed = null):
    list = list.duplicate()
    if _seed:
        seed(_seed)
    var shuffledList = []
    var indexList = range(list.size())
    for i in range(list.size()):
        var x = randi()%indexList.size()
        shuffledList.append(list[x])
        indexList.remove(x)
        list.remove(x)
    return shuffledList
