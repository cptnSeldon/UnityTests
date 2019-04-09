# Home

Current Unity version : 2018.3.5f

## 1. Shaders
### 1.1 Shader Graph

Basic water.

Packages used : 
- Shader Graph (v4.10.0)
- Lightweight Render Pipeline (v4.10.0)

Project Settings/Graphics:
- Scriptable Render Pipeline Settings -> Assets/1_1_ShaderGraph/Helpers/LightweightRenderPipelineAsset.asset

#### Links
- [Basic water using Shader Graph in Unity - PolyToots](https://youtu.be/uuzB93F39P8)
- [Water normal map](https://blenderartists.org/t/animated-water-normal-map-tileable-looped/673140)

### 1.2 Handwritten Shaders
#### 1.2.1 Texture Distortion

Faking liquid.

- Adjust UV coordinates with a flow map.
- Create a seamless animation loop.
- Control the flow appearance.
- Use a derivative map to add bumps.

Project Settings/Graphics:
- Scriptable Render Pipeline Settings -> None

##### Link
- [Texture distorsion - Catlike coding](https://catlikecoding.com/unity/tutorials/flow/texture-distortion/)

#### 1.2.2 Directional Flow

Tiling Liquid.

- Align a texture with the flow direction.
- Partition the surface into tiles.
- Seamlessly blend tiles.
- Obfuscate visual artifacts.

Project Settings/Graphics:
- Scriptable Render Pipeline Settings -> None

##### Link 
- [Directional Flow - Catlike coding](https://catlikecoding.com/unity/tutorials/flow/directional-flow/)
