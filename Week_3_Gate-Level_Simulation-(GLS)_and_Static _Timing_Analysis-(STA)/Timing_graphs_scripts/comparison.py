import matplotlib.pyplot as plt
import numpy as np

# Corners
corners = [
    "ff_100C_1v65","ff_100C_1v95","ff_n40C_1v56","ff_n40C_1v65",
    "ff_n40C_1v76","ff_n40C_1v95","tt_025C_1v80","tt_100C_1v80",
    "ss_100C_1v40","ss_100C_1v60","ss_n40C_1v28","ss_n40C_1v35",
    "ss_n40C_1v40","ss_n40C_1v44","ss_n40C_1v60","ss_n40C_1v76"
]

# Metrics
max_slack = [
     1.8464, 3.2659, 0.4378,1.4603, 
     2.3565, 3.4382, 0.4581, 0.5230,
    -13.9015, -7.0384, -77.3905, -46.0748,
    -33.7707, -27.8124, -11.6771, -5.2641
]

min_slack = [
    -0.2509, -0.3040, -0.2085,-0.2449, 
    -0.2757, -0.3125, -0.1904,-0.1855,
    0.4053, 0.1420, 0.6461, 0.6229,
    0.6119, 0.4909, 0.1628, 0.0038
]

wns = [
    0.0, 0.0, 0.0, 0.0,
    0.0, 0.0, 0.0, 0.0,
    -13.9015, -7.0384, -77.3905, -46.0748,
    -33.7707, -27.8124, -11.6771, -5.2641
]

tns = [
    0.0, 0.0, 0.0, 0.0,
    0.0, 0.0, 0.0, 0.0,
    -8745.7207, -3564.3682, -39948.4492, -25433.4102,
    -18960.8887, -15219.0166, -6229.2100, -2566.9700
]

x = np.arange(len(corners))

# Function to plot bar + line for a single metric
def plot_metric(x, corners, values, metric_name, color):
    plt.figure(figsize=(16,5))
    
    # Bar Plot
    plt.subplot(1,2,1)
    plt.bar(x, values, color=color)
    plt.xticks(x, corners, rotation=45, ha='right')
    plt.ylabel('Slack (ns)')
    plt.title(f'{metric_name} - Bar Plot')
    for i, val in enumerate(values):
        plt.text(i, val, f"{val:.2f}", ha='center', va='bottom' if val>=0 else 'top', fontsize=8)
    plt.grid(axis='y')
    
    # Line Plot
    plt.subplot(1,2,2)
    plt.plot(x, values, marker='o', linestyle='-', color=color)
    plt.xticks(x, corners, rotation=45, ha='right')
    plt.ylabel('Slack (ns)')
    plt.title(f'{metric_name} - Line Plot')
    plt.grid(True)
    
    plt.tight_layout()
    plt.show()

# Plot each metric individually for better clarity
plot_metric(x, corners, max_slack, "Max Slack", "blue")
plot_metric(x, corners, min_slack, "Min Slack", "green")
plot_metric(x, corners, wns, "WNS", "red")
plot_metric(x, corners, tns, "TNS", "purple")

