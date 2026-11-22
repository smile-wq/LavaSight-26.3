# 岩浆透视 · LavaSight

适用于 Minecraft Java 版 26.3（资源包格式 97.1）。从岸上能隔着淡橙色的岩浆看见池底，流动的岩浆会保留方向纹路。基础包只替换岩浆纹理，潜入岩浆后的视距由客户端的雾效设置决定。

## 安装

1. 在游戏中打开「选项 → 资源包 → 打开资源包文件夹」。
2. 将 [LavaSight-26.3.zip](dist/LavaSight-26.3.zip) 原样复制进去。
3. 回到资源包列表，启用「LavaSight-26.3」并点「完成」。同时使用其他修改岩浆纹理的资源包时，将本包移到它们上方。

使用 Sodium 的客户端只需启用基础包，已在 Minecraft 26.3 和 Sodium 0.9.2 上验证。可以在创造模式找一处岩浆池，从岸上看向池底，检查静止和流动岩浆的透明效果。

### 原版渲染器的可选雾效

使用 26.3 原版渲染器时，可同时启用 [LavaSight-26.3-VanillaFog.zip](dist/LavaSight-26.3-VanillaFog.zip)。这个附加包在普通、抗火和旁观状态下减弱岩浆内的近雾，远处仍按渲染距离淡出。它会覆盖原版的 `fog.glsl`，Sodium 会对此文件给出兼容性提示。[Sodium 的资源包说明](https://github.com/CaffeineMC/sodium/wiki/Resource-Packs)

## 编辑与打包

可编辑的资源在 [pack](pack/) 中。静止和流动岩浆分别使用 16×16 和 32×32 像素的动画帧。可直接编辑两张 PNG，或调整 [纹理生成脚本](tools/generate_textures.py) 中调色板的第四个数值来改变不透明度。重新生成纹理时需要 Python 和 Pillow。

在项目根目录运行以下命令，可分别生成基础包和原版雾效附加包。

```sh
python -m zipfile -c dist/LavaSight-26.3.zip pack/pack.mcmeta pack/pack.png pack/assets
python -m zipfile -c dist/LavaSight-26.3-VanillaFog.zip vanilla-fog/pack.mcmeta pack/pack.png vanilla-fog/assets
```

调整附加包的岩浆内视距时，编辑 [fog.glsl](vanilla-fog/assets/minecraft/shaders/include/fog.glsl)。移植到其他版本时，请先核对客户端的岩浆雾参数和着色器接口。[Java 26.3 官方版本说明](https://www.minecraft.net/en-us/article/minecraft-java-edition-26-3)
