"""

demo make sine sample and play

source:
https://godotengine.org/qa/28685/is-it-possible-to-make-the-audio-data-in-gdscript-only


"""
tool
extends Node

func _ready():
    GenerateAndPlay()



func ShortToBytes(value): # value: 16 bit INTEGER! [0 - 65535]
    var bytes = PoolByteArray()
    var X = value / 255
    bytes.append(value - X - 128) # are godot bytes signed or unsigned?
    bytes.append(X - 128)
    return bytes

func GenerateAndPlay():
    # generate data
    var audio_buffer = PoolByteArray()
    var samples_per_second = AudioServer.get_mix_rate()
    var length = int(samples_per_second * 2.5) # length in number of samples (here 2.5 seconds)

    for i in range(0, length): # for number of samples
        var sample = int(sin(float(i) / samples_per_second * 440.0 * PI * 2.0) * 16000 + 16000) # generate a 440 Hz sine wave
        audio_buffer.append_array(ShortToBytes(sample))

    # create sample from generated data
    var sample = AudioStreamSample.new()
    sample.data = audio_buffer
    sample.format = AudioStreamSample.FORMAT_16_BITS
    sample.loop_mode = AudioStreamSample.LOOP_DISABLED
    sample.loop_begin = 0
    sample.loop_end = 0
    sample.mix_rate = samples_per_second
    sample.stereo = false

    # create audio stream player & play sample
    var asp = AudioStreamPlayer.new()
    asp.volume_db = -13.0 # don't blast your ears!
    asp.stream = sample # set the sample as source
    add_child(asp) # add stream player to the scene tree so the output is heard
    asp.play()


