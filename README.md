# TYPop
##一、简介  
一款通用的弹窗组件，使用dart语言，适用于flutter应用  

##二、使用  
```
初始化：
//（1）用到动画，所以需要mixin SingleTickerProviderStateMixin
class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin
//（2）init方法里面初始化AnimationController实例
  late AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =  AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
  }
// 1.显示弹窗，默认最多显示1个
    TYPop pop = TYPop();
    Widget textWidget = const Text("123456", style: TextStyle(
        fontSize: 33,
        decoration: TextDecoration.none
    ));
    pop.show(
        popH: 200, popW: 300,
        controller: controller,
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            textWidget,
            TextButton(onPressed: (){
              pop.dismiss(controller: controller);
            }, child: Container(color: Colors.grey, width: 100, height: 100,))
          ],
        ));
// 2.隐藏弹窗  
   pop.dismiss(controller: controller);
// 3.显示多个弹窗，超过maxCount限制后会从栈底开始移除弹窗
    TYPop pop = TYPop();
    pop.maxCount = 2;
    for (int i = 0; i < 3 ; i ++) {
      Widget textWidget = Text("当前${i + 1}", style: const TextStyle(
          fontSize: 33,
          decoration: TextDecoration.none
      ));
      pop.show(
          popH: 200, popW: 300,
          controller: controller,
          widget: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              textWidget,
              TextButton(onPressed: (){
                pop.dismiss(controller: controller);
              }, child: Container(color: Colors.grey, width: 100, height: 100,))
            ],
          ));

```



