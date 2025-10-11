import matplotlib.pyplot as plt

# corners
corners = [
    "ff_100C_1v65","ff_100C_1v95","ff_n40C_1v56","ff_n40C_1v65",
    "ff_n40C_1v76","ff_n40C_1v95","tt_025C_1v80","tt_100C_1v80",
    "ss_100C_1v40","ss_100C_1v60","ss_n40C_1v28","ss_n40C_1v35",
    "ss_n40C_1v40","ss_n40C_1v44","ss_n40C_1v60","ss_n40C_1v76"
]

# Max/Worst max slack
max_slack = [
     1.8464, 3.2659, 0.4378,1.4603, 
     2.3565, 3.4382, 0.4581, 0.5230,
    -13.9015, -7.0384, -77.3905, -46.0748,
    -33.7707, -27.8124, -11.6771, -5.2641
]

# Min/Worst min slack
min_slack = [
    -0.2509, -0.3040, -0.2085,-0.2449, 
    -0.2757, -0.3125, -0.1904,-0.1855,
    0.4053, 0.1420, 0.6461, 0.6229,
    0.6119, 0.4909, 0.1628, 0.0038
]

# Worst Negative slack (wns)
wns = [
    0.0, 0.0, 0.0, 0.0,
    0.0, 0.0, 0.0, 0.0,
    -13.9015, -7.0384, -77.3905, -46.0748,
    -33.7707, -27.8124, -11.6771, -5.2641
]
# Total Negative Slack (tns)
tns = [
    0.0, 0.0, 0.0, 0.0,
    0.0, 0.0, 0.0, 0.0,
    -8745.7207, -3564.3682, -39948.4492, -25433.4102,
    -18960.8887, -15219.0166, -6229.2100, -2566.9700
]

# Plotting function
def plot_metric(y_values, title, color, ylabel):
    plt.figure(figsize=(16,5))
    plt.plot(corners, y_values, marker='o', linestyle='-', color=color)
    plt.title(title)
    plt.xticks(rotation=45, ha="right")
    plt.ylabel(ylabel)
    for i, val in enumerate(y_values):
        plt.text(i, val, f"{val:.4f}", ha='center', va='bottom' if val>0 else 'top', fontsize=8)
    plt.grid(True)
    plt.tight_layout()
    plt.show()

# Plot all four graphs
plot_metric(max_slack, "Max/Worst Max Slack Across Corners", "blue", "Slack (ns)")
plot_metric(min_slack, "Min/Worst Min Slack Across Corners", "green", "Slack (ns)")
plot_metric(wns, "Worst Negative Slack (WNS) Across Corners", "red", "Slack (ns)")
plot_metric(tns, "Total Negative Slack (TNS) Across Corners", "purple", "Slack (ns)")

