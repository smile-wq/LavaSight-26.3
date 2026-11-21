# 岩浆透视 · LavaSight

适用于 Minecraft Java 版 26.3（资源包格式 97.1）。从岸上能隔着淡橙色的岩浆看见池底，流动的岩浆会保留方向纹路。视角没入岩浆时，近处的橙雾会散去，远处仍按游戏的渲染距离淡出。普通状态、抗火效果和旁观模式均已纳入处理。

## 安装

1. 在游戏中打开「选项 → 资源包 → 打开资源包文件夹」。
2. 将 [LavaSight-26.3.zip](dist/LavaSight-26.3.zip) 原样复制进去。
3. 回到资源包列表，启用「LavaSight-26.3」并点「完成」。同时使用其他修改岩浆或雾效的资源包时，将本包移到它们上方。

可以在创造模式找一处岩浆池，从岸上看向池底，再潜入池中确认视野。包内的雾效针对 26.3 原版渲染器编写。第三方光影若接管雾效，入浆后的视距由该光影决定。

## 编辑与打包

可编辑的资源在 [pack](pack/) 中。静止和流动岩浆分别使用 16×16 和 32×32 像素的动画帧。可直接编辑两张 PNG，或调整 [纹理生成脚本](tools/generate_textures.py) 中调色板的第四个数值来改变不透明度。重新生成纹理时需要 Python 和 Pillow。

在项目根目录运行以下命令即可用 Python 标准库重新打包。

```sh
python -m zipfile -c dist/LavaSight-26.3.zip pack/pack.mcmeta pack/pack.png pack/assets
```

岩浆内视野由 [fog.glsl](pack/assets/minecraft/shaders/include/fog.glsl) 控制。移植到其他版本时，请先核对客户端的岩浆雾参数和着色器接口。[Java 26.3 官方版本说明](https://www.minecraft.net/en-us/article/minecraft-java-edition-26-3)
