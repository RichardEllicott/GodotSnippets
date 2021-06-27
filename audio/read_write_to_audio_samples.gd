"""

Zylan created code to read and write audio samples:

https://godotengine.org/qa/67091/how-to-read-audio-samples-as-1-1-floats?show=67094#a67094

shows some discrepancies, may explain why i failed doing this last time

"""


static func read_8bit_samples(stream: AudioStreamSample) -> Array:
    assert(stream.format == AudioStreamSample.FORMAT_8_BITS)
    var bytes = stream.data
    var samples = []
    for i in len(bytes):
        var b = bytes[i]
        # Despite what the doc says, PoolByteArray contains uint8_t values,
        # which are unsigned bytes representing signed numbers.
        # In GDScript, we still get positive integers, i.e -2 => 253.
        # So we bring back their representation as unsigned,
        # emulating the 8-bit wrapping behavior.
        var u = (b + 128) & 0xff
        # Then bring back to signed -1..1 range
        var s = float(u - 128) / 128.0
        samples.append(s)
    return samples


static func read_16bit_samples(stream: AudioStreamSample) -> Array:
    assert(stream.format == AudioStreamSample.FORMAT_16_BITS)
    var bytes = stream.data
    var samples = []
    var i = 0
    # Read by packs of 2 bytes
    while i < len(bytes):
        var b0 = bytes[i]
        var b1 = bytes[i + 1]
        # Combine low bits and high bits to obtain 16-bit value
        var u = b0 | (b1 << 8)
        # Emulate signed to unsigned 16-bit conversion
        u = (u + 32768) & 0xffff
        # Convert to -1..1 range
        var s = float(u - 32768) / 32768.0
        samples.append(s)
        i += 2
    return samples


static func write_8bit_samples(samples: Array) -> AudioStreamSample:
    var bytes = PoolByteArray()
    bytes.resize(len(samples))
    for i in len(samples):
        var u = int(samples[i] * 128.0) + 128
        # Godot will internally cast to byte so we don't need to emulate it.
        # This is the only part the doc explains accurately.
        bytes[i] = u - 128
    var stream = AudioStreamSample.new()
    stream.stereo = false
    stream.format = AudioStreamSample.FORMAT_8_BITS
    stream.data = bytes
    return stream


static func write_16bit_samples(samples: Array) -> AudioStreamSample:
    var bytes = PoolByteArray()
    bytes.resize(len(samples) * 2)
    for i in len(samples):
        var j = i * 2
        var u = int(samples[i] * 32768.0) + 32768
        # Emulate cast from unsigned to signed
        u = (u - 32768) & 0xffff
        # Assign low and high byte
        bytes[j] = u & 0xff
        bytes[j + 1] = u >> 8
    var stream = AudioStreamSample.new()
    stream.stereo = false
    stream.format = AudioStreamSample.FORMAT_16_BITS
    stream.data = bytes
    return stream