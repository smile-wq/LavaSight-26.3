# 岩浆透视 · LavaSight

适用于 Minecraft Java 版 26.3（资源包格式 97.1）。从岸上能隔着淡橙色的岩浆看见池底，流动的岩浆会保留方向纹路。基础包只替换岩浆纹理，潜入岩浆后的视距由客户端的雾效设置决定。

## 安装

在游戏中打开「选项 → 资源包 → 打开资源包文件夹」。按下表选择 ZIP，原样复制进去，在资源包列表中启用并点「完成」。若有其他包也修改岩浆纹理或雾着色器，将选用的 LavaSight 包移到它们上方。

| 使用场景 | 资源包和设置 |
| --- | --- |
| Sodium 0.9.2，想看清岩浆里的地形 | [Sodium 独立包](dist/LavaSight-26.3-Sodium.zip)。要看远，在视频设置中关闭「使用雾遮挡剔除」 |
| 26.3 原版渲染器，想在岩浆里看远 | [基础包](dist/LavaSight-26.3.zip) 和 [原版雾效附加包](dist/LavaSight-26.3-VanillaFog.zip) |
| 只想从岸上看清池底 | [基础包](dist/LavaSight-26.3.zip) |

### Sodium 独立包的可见范围

独立包包含静止和流动岩浆纹理、Sodium 的地形雾着色器，以及实体等由原版绘制的内容使用的雾着色器。

启用独立包后，在「选项 → 视频设置 → 性能」中关闭「使用雾遮挡剔除」（Use Fog Occlusion），就能在第一人称下潜时看清远处地形。这个开关对整个客户端生效，也可以在退出游戏后将实例 `config/sodium-options.json` 中的 `performance.use_fog_occlusion` 设为 `false`。单人测试使用 Minecraft 26.3、Sodium 0.9.2 和 8 区块渲染距离，关闭了 Iris 光影。生存玩家在没有抗火效果时潜入岩浆，能看清前方 41.5 格处的方块墙。

Tweakeroo 的「灵魂出窍」在游戏选取雾效时让相机返回 `FogType.NONE`。资源包的着色器在钠选好要绘制的区块段后才运行。雾遮挡剔除默认开启，钠会按原始岩浆雾距选取 16×16×16 区块段。开启时，实测能看清同一区块段内 3.5 格外的方块。墙移到 9.5 格外、跨入下一区块段后，该位置只剩雾色。可见范围取决于相机与区块段边界的位置。[Tweakeroo 的相机雾类型](https://github.com/sakura-ryoko/tweakeroo/blob/26.3/src/main/java/fi/dy/masa/tweakeroo/mixin/freecam/MixinCamera_freeCam.java#L15-L22) · [Sodium 的区块段搜索距离](https://github.com/CaffeineMC/sodium/blob/mc26.3-0.9.2/common/src/main/java/net/caffeinemc/mods/sodium/client/render/chunk/RenderSectionManager.java#L364-L374)

独立包在 `pack.mcmeta` 的 `sodium.ignored_shaders` 中列出了 `fog.glsl`，向钠声明包内的 `minecraft:shaders/include/fog.glsl` 不用于钠的地形，钠因此不会弹出兼容性提示。钠的地形使用包中的 `sodium:shaders/include/fog.glsl`。[钠的资源包检查](https://github.com/CaffeineMC/sodium/blob/mc26.3-0.9.2/common/src/main/java/net/caffeinemc/mods/sodium/client/checks/ResourcePackScanner.java)

### 使用 Sodium Extra 控制岩浆内视距

在 Sodium 0.9.2 搭配 Sodium Extra 0.9.4 时，启用基础包，并在 Sodium Extra 的雾效设置中打开高级模式和 `Protected Gameplay Fog`，将 `Lava Fog` 设为 `Off`。也可以在退出游戏后编辑实例的 `config/sodium-extra-options.json`。

| `render_settings.fog_settings` 下的字段 | 取值 |
| --- | --- |
| `advanced` | `true` |
| `protected_gameplay.enabled_when_allowed` | `true` |
| `protected_gameplay.lava_distance_blocks` | `-1` |

岩浆雾距设为 `-1` 会关闭近雾，`0` 恢复默认，正数指定雾的终点距离（格）。Sodium Extra 在私人单人世界、允许作弊的局域网世界，以及通过 Greenlight 授权的服务器上应用这组选项。

### 原版渲染器的可选雾效

使用 26.3 原版渲染器时，可同时启用 [LavaSight-26.3-VanillaFog.zip](dist/LavaSight-26.3-VanillaFog.zip)。这个附加包在普通、抗火和旁观状态下减弱岩浆内的近雾，远处仍按渲染距离淡出。它也识别 Tweakeroo 0.30.1 的「岩浆可视」改写后的雾距。附加包会覆盖原版的 `fog.glsl`，并同样在 `pack.mcmeta` 中向钠声明了这个文件，与钠同时安装时不会弹出兼容性提示。钠的地形使用自己的雾着色器，不受附加包影响，使用钠时请改用 Sodium 独立包。[Sodium 的资源包说明](https://github.com/CaffeineMC/sodium/wiki/Resource-Packs)

## 编辑与打包

可编辑的资源在 [pack](pack/) 中。静止和流动岩浆分别使用 16×16 和 32×32 像素的动画帧。可直接编辑两张 PNG，或调整 [纹理生成脚本](tools/generate_textures.py) 中调色板的第四个数值来改变不透明度。重新生成纹理时需要 Python 和 Pillow。

在项目根目录运行以下命令，可分别生成基础包、原版雾效附加包和 Sodium 独立包。

```sh
python -m zipfile -c dist/LavaSight-26.3.zip pack/pack.mcmeta pack/pack.png pack/assets
python -m zipfile -c dist/LavaSight-26.3-VanillaFog.zip vanilla-fog/pack.mcmeta pack/pack.png vanilla-fog/assets
python tools/build_sodium_pack.py
```

修改岩浆雾时，按渲染路径编辑[原版雾着色器](vanilla-fog/assets/minecraft/shaders/include/fog.glsl)或[钠地形雾着色器](sodium/assets/sodium/shaders/include/fog.glsl)。移植到其他版本时，请先核对客户端的岩浆雾参数和着色器接口。[Java 26.3 官方版本说明](https://www.minecraft.net/en-us/article/minecraft-java-edition-26-3)
