import numpy as np

# Parameters
num_lines = 25
time_interval = 1040  # Time interval between data points
num_vaunx = 16  # Number of VAUXP/VAUXN pairs

# Generate time values
time = np.arange(0, num_lines * time_interval, time_interval)

# Generate sinusoidal function values
freq = 0.01  # Frequency of the sinusoidal function
amplitude = 0.1  # Amplitude of the sinusoidal function
sinusoidal_values = amplitude * np.sin(2 * np.pi * freq * time)

# Create the data
data = []
for t, value in zip(time, sinusoidal_values):
    row = [int(t)]
    row.extend([63.0, 1.02, 1.02, 1.8, 0.0, 0.0])  # Constants: TEMP, VCCINT, VCCBRAM, VCCAUX, VP, VN
    row.extend([value, 0.0] * num_vaunx)  # VAUXP and VAUXN pairs
    data.append(row)

# Print the data
print("TIME    TEMP   VCCINT   VCCBRAM   VCCAUX   VP     VN    ", end="")
for i in range(num_vaunx):
    print(f"VAUXP[{i}]   VAUXN[{i}]   ", end="")
print()
for row in data:
    print(" ".join(map(str, row)) + " //")
