"""

should be added as a singleton to autoloads as "mylib"

contains helper functions

method for loading this file like a dynamic object:
const MyLib = preload("eemylib.gd")
onready var mylib = MyLib.new()
would create this everyplace it is written


functions so far:
    find(name) #find anything


"""
extends Node

