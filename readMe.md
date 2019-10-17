#拖入项目中通过设置byScale来使约束按比例布局
实现原理 通过运行时交换 awakeFromNib 来达到  通过视图树 传递 byScale 标识位，
通过byScale标识来进行约束 比例限制， 
