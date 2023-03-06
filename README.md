# TYPop
##一、简介
一款通用的弹窗组件，使用dart语言，适用于flutter应用

##二、使用
```
// 1、显示带动画效果的弹窗
    showCenterAlertWithAnimation(
      controller: controller,
      child: const Center(
        child: Text("123456", style: TextStyle(color: Colors.blueAccent, fontSize: 33, decoration: TextDecoration
            .none),),
      ),
      popH: 200,
      popW: 300,
    );
    
// 2、隐藏带动画效果的弹窗
    dismissAlertWithAnimation(controller: controller);
    
// 3、显示不带动画的弹窗
    tyShowPop();
    
// 4、隐藏不带动画的弹窗
    tyDismissPop();
    
```
