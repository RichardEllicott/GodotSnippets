"""

physics layers can be irritating

this arrangement has 4 "teams":

	player
	enemy
	team3
	team4

essentially a player for example, can then fire a playerbullet and it will not hit anything also on the player team

bulletclash variants mean bullets that should hit other bullets




"""


enum CollisionPreset{ #enumerators for the presets
    none,
    player,
    playerbullet,
    playerbulletclash,
    enemy,
    enemybullet,
    enemybulletclash,
    team3,
    team3bullet,
    team3bulletclash,
    team4,
    team4bullet,
    team4bulletclash,
    wall,
    }


var collisionPresets= { # the preset mask 
    CollisionPreset.player: [1, 65520],
    CollisionPreset.playerbullet:[2, 56784],
    CollisionPreset.playerbulletclash:[4, 65520],
    CollisionPreset.enemy:[16, 65295],
    CollisionPreset.enemybullet:[32, 56589],
    CollisionPreset.enemybulletclash:[64, 65295],
    CollisionPreset.team3:[256, 61695],
    CollisionPreset.team3bullet:[512, 53469],
    CollisionPreset.team3bulletclash:[1024, 61695],
    CollisionPreset.team4:[4096, 4095],
    CollisionPreset.team4bullet:[8192, 3549],
    CollisionPreset.team4bulletclash:[16384, 4095],
    CollisionPreset.wall:[65535, 65535],
   }


export (CollisionPreset) var collision_preset = CollisionPreset.none # for example to set this in the GUI 


func update_collision_preset(): # you could run this on the _ready, in a KB

    if collision_preset != CollisionPreset.none:
        var preset = collisionPresets[collision_preset]
        collision_layer = preset[0]
        collision_mask = preset[1]



