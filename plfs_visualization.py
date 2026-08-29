import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Load data
df = pd.read_csv(r'C:\Users\sparu\Documents\plfs_analytical.csv')

print(df.shape)
print(df.head())

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Load data
df = pd.read_csv(r'C:\Users\sparu\Documents\plfs_analytical.csv')

# State names lookup
state_names = {
    1:'Jammu & Kashmir', 2:'Himachal Pradesh', 3:'Punjab',
    4:'Chandigarh', 5:'Uttarakhand', 6:'Haryana',
    7:'Delhi', 8:'Rajasthan', 9:'Uttar Pradesh',
    10:'Bihar', 11:'Sikkim', 12:'Arunachal Pradesh',
    13:'Nagaland', 14:'Manipur', 15:'Mizoram',
    16:'Tripura', 17:'Meghalaya', 18:'Assam',
    19:'West Bengal', 20:'Jharkhand', 21:'Odisha',
    22:'Chhattisgarh', 23:'Madhya Pradesh', 24:'Gujarat',
    25:'Maharashtra', 27:'Andhra Pradesh', 28:'Karnataka',
    29:'Kerala', 30:'Tamil Nadu', 31:'Telangana',
    32:'Andaman & Nicobar', 33:'Puducherry', 34:'Lakshadweep',
    35:'Goa', 36:'Dadra & NH', 37:'Daman & Diu'
}

sns.set_theme(style='whitegrid', palette='muted')

# ── CHART 1: State ranking (top 10 vs bottom 10) ──
state_prot = df.groupby('st')['social_prot'].mean().reset_index()
state_prot['state_name'] = state_prot['st'].map(state_names)
state_prot['protection_rate'] = state_prot['social_prot'] * 100
state_prot = state_prot.dropna(subset=['state_name']).sort_values('protection_rate')

top10 = state_prot.tail(10)
bot10 = state_prot.head(10)
chart1 = pd.concat([bot10, top10])

fig, ax = plt.subplots(figsize=(10, 8))
colors = ['#d73027']*10 + ['#1a9850']*10
ax.barh(chart1['state_name'], chart1['protection_rate'], color=colors)
ax.axvline(x=state_prot['protection_rate'].mean(), color='navy',
           linestyle='--', label='National average')
ax.set_xlabel('Social Protection Coverage (%)')
ax.set_title('Social Protection Coverage by State\nTop 10 vs Bottom 10 — PLFS 2025',
             fontweight='bold')
ax.legend()
plt.tight_layout()
plt.savefig(r'C:\Users\sparu\Desktop\chart1_states.png', dpi=150)
plt.show()
print("Chart 1 saved")

# ── CHART 2: Education gradient ──
edu_labels = {
    1:'Not literate', 5:'Below primary', 6:'Primary',
    7:'Middle', 8:'Secondary', 10:'Higher secondary',
    11:'Diploma', 12:'Graduate', 13:'Postgraduate'
}
edu_prot = df.groupby('edu_num')['social_prot'].mean().reset_index()
edu_prot['label'] = edu_prot['edu_num'].map(edu_labels)
edu_prot = edu_prot.dropna(subset=['label'])
edu_prot['protection_rate'] = edu_prot['social_prot'] * 100

fig, ax = plt.subplots(figsize=(10, 5))
ax.plot(edu_prot['label'], edu_prot['protection_rate'],
        marker='o', color='steelblue', linewidth=2.5, markersize=8)
ax.set_xlabel('Education Level')
ax.set_ylabel('Social Protection Coverage (%)')
ax.set_title('Social Protection Coverage by Education Level — PLFS 2025',
             fontweight='bold')
plt.xticks(rotation=30, ha='right')
plt.tight_layout()
plt.savefig(r'C:\Users\sparu\Desktop\chart2_education.png', dpi=150)
plt.show()
print("Chart 2 saved")

# ── CHART 3: Urban vs Rural by contract type ──
contract_labels = {1:'Written', 2:'Oral fixed', 3:'Oral non-fixed', 4:'No contract'}
df2 = df.dropna(subset=['job_pas', 'social_prot', 'urban'])
df2 = df2[df2['job_pas'].isin([1,2,3,4])]
df2['contract'] = df2['job_pas'].map(contract_labels)
df2['location'] = df2['urban'].map({1:'Urban', 0:'Rural'})

grp = df2.groupby(['contract','location'])['social_prot'].mean().reset_index()
grp['protection_rate'] = grp['social_prot'] * 100

fig, ax = plt.subplots(figsize=(9, 5))
sns.barplot(data=grp, x='contract', y='protection_rate',
            hue='location', palette=['#74add1','#f46d43'], ax=ax)
ax.set_xlabel('Contract Type')
ax.set_ylabel('Social Protection Coverage (%)')
ax.set_title('Social Protection by Contract Type and Location — PLFS 2025',
             fontweight='bold')
plt.tight_layout()
plt.savefig(r'C:\Users\sparu\Desktop\chart3_contract_urban.png', dpi=150)
plt.show()
print("Chart 3 saved")

print("\nAll charts saved to Desktop.")