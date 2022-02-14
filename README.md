# EasyReader

**EasyReader** 是一款小说阅读器的Demo，理论支持所有纯文本（或继承于纯文本的格式）、RTF(D)、PDF、EPUB的阅览。

&nbsp;

## 使用说明

在从外部导入文档文件后，点击打开，退出软件后文件可保存至App缓存，以便下次使用。

&nbsp;

## 现有功能

- 对于纯文本、RTF(D)：
    - 改变文字大小
    - 改变阅读背景

- 对于PDF：
    - 平滑阅览
    - 改变阅览姿势（横向/纵向）
    - 总览缩略图（Thumbnail）

- 对于EPUB：
    - 翻页阅览

&nbsp;

## 开发小结

### 技术使用

本项目主要由**UIKit** + **Combine**开发。

### 实现思路

App主要依赖外界导入文本文件，复制到软件缓存中，并在UserDefaults中保存URL。

### 开源框架

- [CombineCocoa](https://github.com/CombineCommunity/CombineCocoa)
> Combine实用extensions

- [Defaults](https://github.com/sindresorhus/Defaults)
> 封装完善的UserDefaults wrapper

- [EPUBKit](https://github.com/witekbobrowski/EPUBKit)
> 解包EPUB文件的框架

- [SnapKit](https://github.com/SnapKit/SnapKit)
> 封装完善的约束框架

- [SwiftyBeaver](https://github.com/SwiftyBeaver/SwiftyBeaver)
> Logging框架


