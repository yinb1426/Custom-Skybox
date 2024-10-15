# 自定义天空盒
## 概述
自定义天空盒，提供清晨、白天、黄昏、深夜**天空颜色**的配置，**太阳、月亮、星空**等相关参数设置，并提供云层、星空、极光等显示选项。
## 特性
* 提供清晨、白天、黄昏、深夜，4段时间天空颜色的配置
* 提供太阳、月亮、星空相关参数的配置
* 提供噪声云层显示选项及其相关参数配置
* 提供星空显示选项及其相关参数配置
* 提供极光显示选项及其相关参数配置
## 使用说明
1. 请创建Unity URP工程以使用此天空盒
2. 在“Window-Rendering-Lighting”菜单中，选择Environment选项卡中的“Skybox Material”选择本天空盒
3. 在场景中创建空GO，将脚本SkyboxController.cs挂载在本GO上，并设置天空盒材质与主灯光参数即可。
> SkyboxController.cs脚本用于控制时间流动，以及主灯光位置与旋转参数
## Shader参数
**常规**：
| 参数 | 类型 | <center>说明</center> | 建议参考值 |
| :------: | :------: | :------ | :------: |
| CurrentTime | Range(0, 24) | 当前时间，由SkyboxController.cs脚本控制 | |

**太阳与月亮**：
| 参数 | 类型 | <center>说明</center> | 建议参考值 |
| :------: | :------: | :------ | :------: |
| SunColor | Color[HDR] | 日光颜色 | (2.996078, 2.996078, 2.996078, 1, 2)
| SunRadius | Float | 太阳尺寸半径 | 0.05 |
| SunStrength | Float | 控制太阳范围与强度的系数 | 50.0 |
| MoonColor | Color[HDR] | 月光颜色 |(2.996079, 2.530082, 0.6660917, 1, 2) |
| MoonRadius | Float | 月亮尺寸半径 | 0.05 |
| MoonStrength | Float | 控制月亮范围与强度的系数 | 50.0 |
| MoonCrescenOffset | Range(-0.1, 0.1) | 月牙遮挡偏移程度 | 0.1 |

**泛光**：
| 参数 | 类型 | <center>说明</center> | 建议参考值 |
| :------: | :------: | :------ | :------: |
| BloomRadius | Float | 泛光区域半径 | 0.6 |
| BloomStrength | Float | 控制泛光强度的系数 | 0.4 |
| MorningBloomColor | Color | 清晨泛光颜色 | (198, 175, 164, 255) |
| AfternoonBloomColor | Color | 白天泛光颜色 | (255, 255, 255, 255) |
| DuskBloomColor | Color | 黄昏泛光颜色 | (255, 151, 39, 255) |
| NightBloomColor | Color | 深夜泛光颜色 | (57, 73, 93, 255) |

**清晨天空**：
| 参数 | 类型 | <center>说明</center> | 建议参考值 |
| :------: | :------: | :------ | :------: |
| MorningTopColor | Color | 清晨天空上部颜色 | (78, 123, 211, 255) |
| MorningBottomColor | Color | 清晨天空下部颜色 | (229, 149, 98, 255) |
| MorningUpperThreshold | Float | 清晨天空混色区间中间值 | 0.2 |
| MorningUpperRange | Float | 清晨天空混色半区间值 | 0.4 |
| MorningTime | Vector | 清晨天空起止时间区间 | (5, 7, 8, 10) | 
> 起止时间区间定义：xy为上时间段天空颜色和本时间段天空颜色的混色区间，zw本时间段天空颜色和下时间段天空颜色的混色区间。例：5-7时为深夜天空颜色和清晨天空颜色的混合时间，7-8时为纯清晨天空颜色时间，8-10时为清晨天空颜色和白天天空颜色的混合时间。

**白天天空**：
| 参数 | 类型 | <center>说明</center> | 建议参考值 |
| :------: | :------: | :------ | :------: |
| AfternoonTopColor | Color | 白天天空上部颜色 | (50, 135, 211, 255) |
| AfternoonBottomColor | Color | 白天天空下部颜色 | (186, 254, 255, 255) |
| AfternoonUpperThreshold | Float | 白天天空混色区间中间值 | 0.0 |
| AfternoonUpperRange | Float | 白天天空混色半区间值 | 0.6 |
| AfternoonTime | Vector | 白天天空起止时间区间 | (8, 10, 16, 18) | 

**黄昏天空**：
| 参数 | 类型 | <center>说明</center> | 建议参考值 |
| :------: | :------: | :------ | :------: |
| DawnTopColor | Color | 黄昏天空上部颜色 | (77, 89, 158, 255) |
| DawnBottomColor | Color | 黄昏天空下部颜色 | (199, 162, 160, 255) |
| DawnUpperThreshold | Float | 黄昏天空混色区间中间值 | 0.3 |
| DawnUpperRange | Float | 黄昏天空混色半区间值 | 0.2 |
| DawnTime | Vector | 黄昏天空起止时间区间 | (16, 18, 18, 20) | 

**深夜天空**：
| 参数 | 类型 | <center>说明</center> | 建议参考值 |
| :------: | :------: | :------ | :------: |
| NightTopColor | Color | 深夜天空上部颜色 | (0, 10, 24, 255) |
| NightBottomColor | Color | 深夜天空下部颜色 | (31, 42, 56, 255) |
| NightUpperThreshold | Float | 深夜天空混色区间中间值 | 0.2 |
| NightUpperRange | Float | 深夜天空混色半区间值 | 0.2 |
| NightTime | Vector | 深夜天空起止时间区间 | (18, 20, 5, 7) | 

**云层**：
| 参数 | 类型 | <center>说明</center> | 建议参考值 |
| :------: | :------: | :------ | :------: |
| UseCloud | Toggle | 是否显示云层 | √ |
| CloudHeight | Float | 云层高度 | 2.5 |
| CloudBaseNoise | 2D | 云层基底噪声 | |
| CloudFirstNoise | 2D | 云层第一层噪声 | |
| CloudSecondNoise | 2D | 云层第二层噪声 | |
| CloudDirection | Vector | 云层飘动方向(仅xy有效) | (1, 1, 0, 0) |
| CloudSpeed | Float | 云层飘动速度 | 0.008 |
| CloudThreshold | Range(0, 1) | 云层显示区间左边界 | 0.02 |
| CloudRange | Range(0, 1) | 云层显示区间范围 | 0.222 |
| CloudTime | Vector | 云层显示时间 | (22, 23, 4, 5) |

**云层颜色**：
| 参数 | 类型 | <center>说明</center> | 建议参考值 |
| :------: | :------: | :------ | :------: |
| MorningCloudColor | Color | 清晨云层颜色 | (235, 187, 151, 255) |
| AfternoonCloudColor | Color | 白天云层颜色 | (255, 255, 255, 255) |
| DawnCloudColor | Color | 黄昏云层颜色 | (205, 166, 168, 255)|
| NightCloudColor | Color | 深夜云层颜色 | (52, 103, 159, 255) |

**云层消隐**：
| 参数 | 类型 | <center>说明</center> | 建议参考值 |
| :------: | :------: | :------ | :------: |
| UseCloudFade | Toggle | 是否开启云层远处消隐 | √ |
| CloudFadeDistanceThreshold | Range(0, 1) | 云层远处消隐区间左边界 | 0.0 |
| CloudFadeDistanceRange | Range(0, 1) | 云层远处消隐区间左边界 | 0.025 |

**星空**：
| 参数 | 类型 | <center>说明</center> | 建议参考值 |
| :------: | :------: | :------ | :------: |
| StarTexture | 2D | 星空噪声纹理 | |
| StarColor | Color[HDR] | 星星颜色 | (1.513275, 2.556686, 7.373443, 1, 3.299263) |
| StarThreshold | Range(0, 1) | 星空显示区间左边界 | 0.35 |

**极光**：
| 参数 | 类型 | <center>说明</center> | 建议参考值 |
| :------: | :------: | :------ | :------: |
| UseAurora | Toggle | 是否显示极光 | √ |
| AuroraColor | Color | 极光光晕颜色 | (81, 145, 255, 255) |
| AuroraColorFactor | Range(0, 1) | 极光颜色系数 | 0.848 |
| AuroraSpeed | Range(0, 1) | 极光运动速度 | 0.3 |
| AuroraTime | Vector | 极光显示时间 | (22, 23, 3, 4) |

## 实现效果
![SkyboxMorning](https://github.com/yinb1426/Custom-Skybox/blob/main/Pictures/SkyboxMorning.png)
![SkyboxAfternoon](https://github.com/yinb1426/Custom-Skybox/blob/main/Pictures/SkyboxAfternoon.png)
![SkyboxDusk](https://github.com/yinb1426/Custom-Skybox/blob/main/Pictures/SkyboxDusk.png)
![SkyboxNight](https://github.com/yinb1426/Custom-Skybox/blob/main/Pictures/SkyboxNight.png)
![SkyboxNightAurora](https://github.com/yinb1426/Custom-Skybox/blob/main/Pictures/SkyboxNightAurora.png)
## TODO
* 日月贴图显示
* 体积云
* 体积光？
* 其他天空盒可添加的现象(灵感快来!!!)
* ......
