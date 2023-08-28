def arduino_map(value, in_min, in_max, out_min, out_max):
    return (value - in_min) * (out_max - out_min) / (in_max - in_min) + out_min

min_pulse = 500
max_pulse = 2500

mapped_pulse_widths = []

for angle in range(181):
    pulse_width = int(arduino_map(angle, 0, 180, min_pulse, max_pulse))
    mapped_pulse_widths.append(pulse_width)

print(mapped_pulse_widths)
