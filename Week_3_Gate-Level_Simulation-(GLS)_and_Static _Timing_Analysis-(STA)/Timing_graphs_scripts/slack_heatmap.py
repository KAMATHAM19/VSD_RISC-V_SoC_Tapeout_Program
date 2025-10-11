import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

# ----------------------------
# Data: Corner vs Worst Slack
# ----------------------------
data = {
    "Library": [
        "ff_100C_1v65","ff_100C_1v95","ff_n40C_1v56","ff_n40C_1v65","ff_n40C_1v76",
        "ff_n40C_1v95","tt_025C_1v80","tt_100C_1v80","ss_100C_1v40","ss_100C_1v60",
        "ss_n40C_1v28","ss_n40C_1v35","ss_n40C_1v40","ss_n40C_1v44","ss_n40C_1v60","ss_n40C_1v76"
    ],
    "Worst_Slack_Max": [
        1.8464,3.2659,0.4378,1.4603,2.3565,
        3.4382,0.4581,0.5230,-13.9015,-7.0384,
        -77.3905,-46.0748,-33.7707,-27.8124,-11.6771,-5.2641
    ],
    "Worst_Slack_Min": [
        -0.2509,-0.3040,-0.2085,-0.2449,-0.2757,
        -0.3125,-0.1904,-0.1855,0.4053,0.1420,
        0.6461,0.6229,0.6119,0.4909,0.1628,0.0038
    ]
}

df = pd.DataFrame(data)
df.set_index("Library", inplace=True)

# ----------------------------
# Heatmap Plot
# ----------------------------
plt.figure(figsize=(12,6))
sns.heatmap(df, annot=True, cmap="RdYlGn", center=0, linewidths=0.5, linecolor='gray')
plt.title("PVT Corner vs Slack Heatmap (ns)")
plt.ylabel("Library Corner")
plt.xlabel("Slack Type")
plt.tight_layout()
plt.show()

