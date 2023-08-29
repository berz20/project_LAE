import math

# Constants
start_time = 0.0
end_time = 100037.60
num_points = 10000  # Number of data points
amplitude = 0.5  # Amplitude of the sinusoidal wave
frequency = 0.100  # Frequency of the sinusoidal wave

# Generate sinusoidal values
time_values = [start_time + (end_time - start_time) * i / (num_points - 1) for i in range(num_points)]
sinusoidal_values = [abs((0.000015 *2 * math.pi * frequency * t) * math.sin(2 * math.pi * frequency * t)) for t in time_values]

# Print header
print("TIME    TEMP   VCCINT   VCCBRAM   VCCAUX   VP     VN    ", end="")
for i in range(16):
    print(f"VAUXP[{i}]   VAUXN[{i}]   ", end="")
print()

# Print data
for i in range(num_points):
    print(f"{int(time_values[i])*100} {63.0:.1f}  {1.02:.2f}  {1.02:.2f}  {1.8:.1f}  {0.0:.1f}  {0.0:.1f}  {sinusoidal_values[i]:.2f}  ", end="")
    for _ in range(16):
        print(f"0  0  ", end="")
    print("//")



# import math
# import numpy as np
#
# # Constants
# start_time = 0.0
# end_time = 100037.60
# num_points = 10000  # Number of data points
# amplitude = [0.1, 0.2, 0.3, 0.4, 0.5]  # Amplitude of the sinusoidal wave
# frequency = 0.100  # Frequency of the sinusoidal wave
# count = 0
# j = 0
# sinusoidal_values = []
#
# # Generate sinusoidal values
# time_values = [start_time + (end_time - start_time) * i / (num_points - 1) for i in range(num_points)]
# for i in range(0,len(time_values)):
#     if (count > 0.2 * len(time_values)):
#         j += 1
#         count = 0 
#     sinusoidal_values.append( 0.5 + amplitude[j] * math.sin(2 * math.pi * frequency * time_values[i]))
#     count += 1
# # sinusoidal_values = [0.5 + amplitude * math.sin(2 * math.pi * frequency * t) for t in time_values]
#
# # Print header
# print("TIME    TEMP   VCCINT   VCCBRAM   VCCAUX   VP     VN    ", end="")
# for i in range(16):
#     print(f"VAUXP[{i}]   VAUXN[{i}]   ", end="")
# print()
#
# # Print data
# for i in range(num_points):
#     print(f"{int(time_values[i])*100} {63.0:.1f}  {1.02:.2f}  {1.02:.2f}  {1.8:.1f}  {0.0:.1f}  {0.0:.1f}  {sinusoidal_values[i]:.2f}  ", end="")
#     for _ in range(16):
#         print(f"0  0  ", end="")
#     print("//")
