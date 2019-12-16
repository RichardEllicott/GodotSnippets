"""

shuffle an array, optional seed

seed is useful to shuffle a deck of cards the same way for instance


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