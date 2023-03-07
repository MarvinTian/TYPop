import 'package:flutter/material.dart';
import 'main.dart';

/// 弹框内容默认高度
const double defaultHeight = 500;
/// 弹框内容默认宽度
const double defaultWidth = 300;
/// 弹框内容默认圆角
const double defaultRadius = 5;
/// 背景起始透明度
const double defaultBGAlphaFromValue  = 0.0;
/// 背景结束透明度
const double defaultBGAlphaEndValue   = 0.5;
/// 内容起始大小
const double defaultContentFromValue  = 0.5;
/// 内容结束大小
const double defaultContentEndValue   = 1.0;

/// Get
double windowW() => MediaQuery.of(NavigationService.navigatorKey.currentContext!).size.width;
double windowH() => MediaQuery.of(NavigationService.navigatorKey.currentContext!).size.height;
OverlayState curState() => NavigationService.navigatorKey.currentState!.overlay!;

class TYPop {
  /// 弹窗最大堆叠数量
  int maxCount = 1;
  /// 缓存弹窗
  final List<AnimateEntryBuilder> _entryList = [];

  /// 单例方法
  static final TYPop _onceManager = TYPop.internal();

  factory TYPop() {
    return _onceManager;
  }
  TYPop.internal();

  show({
    required AnimationController controller,
    required Widget widget,
    double ?popH,
    double ?popW,
  }) {
    if (_entryList.length == maxCount) {
      // 已达最大数量
      // 移除栈底的弹窗
      dismissFirstObjWithoutAnimation();
    }
    controller.reset();

    AnimateEntryBuilder builder =
    AnimateEntryBuilder(scaleUpAnimation(controller), alphaUpAnimation(controller), widget, popW, popH);
    OverlayEntry overlayEntry = builder.entry!;
    curState().insert(overlayEntry);
    controller.forward();
    // 入栈
    _entryList.add(builder);

  }

  dismiss({required AnimationController controller, int? idx}) {
    if (controller.status == AnimationStatus.forward) {
      print("当前还在动画中");
      return;
    }
    if (_entryList.isEmpty) return;
    late AnimateEntryBuilder topBuilder;
    if (idx != null) {
      topBuilder = _entryList[idx];
    } else {
      topBuilder = _entryList.last;
    }
    topBuilder.scaleAnimation = scaleDownAnimation(controller);
    topBuilder.alphaAnimation = alphaDownAnimation(controller);
    controller.reset();
    controller.forward();

    Future.delayed(controller.duration!, () {
      if (topBuilder.entry != null) {
        topBuilder.entry!.remove();
      }
      // 出栈
      if (idx != null) {
        _entryList.removeAt(idx);
      } else {
        _entryList.removeLast();
      }
    });
  }

  dismissFirstObjWithoutAnimation() {
    if (_entryList.isEmpty) return;
    AnimateEntryBuilder topBuilder = _entryList.first;
    topBuilder.entry!.remove();
    //出栈
    _entryList.removeAt(0);
  }

  /// 动画 - scale增大
  Animation<double> scaleUpAnimation(AnimationController controller) {
    return Tween(
      begin: defaultContentFromValue,
      end: defaultContentEndValue,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(
        0.0, 0.7, //间隔，前70%的动画时间
        curve: Curves.easeIn, // 慢入快出，前70%慢入
      ),
    ),);
  }

  /// 动画 - alpha增大
  Animation<double> alphaUpAnimation(AnimationController controller) {
    return Tween(
        begin: defaultBGAlphaFromValue,
        end: defaultBGAlphaEndValue
    ).animate(controller);
  }

  /// 动画 - scale变小
  Animation<double> scaleDownAnimation(AnimationController controller) {
    return Tween(
      begin: defaultContentEndValue,
      end: defaultContentFromValue,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(
        0.0, 0.7, //间隔，前70%的动画时间
        curve: Curves.easeIn, // 慢入快出，前70%慢入
      ),
    ),);
  }

  /// 动画 - alpha变小
  Animation<double> alphaDownAnimation(AnimationController controller) {
    return Tween(
        begin: defaultBGAlphaEndValue,
        end: defaultBGAlphaFromValue
    ).animate(controller);
  }

}

class AnimateEntryBuilder {

  /// 容器scale动画
  Animation<double>? scaleAnimation;

  /// 背景alpha动画
  Animation<double>? alphaAnimation;
  Widget? widget;
  double? popW;
  double? popH;
  OverlayEntry? entry;

  AnimateEntryBuilder(
      this.scaleAnimation,
      this.alphaAnimation,
      this.widget,
      this.popW,
      this.popH) {
    entry = OverlayEntry(builder: (ctx){
      return AnimatedBuilder(animation: scaleAnimation!, builder: (BuildContext ctx, child){
        if (scaleAnimation!.value <= defaultContentFromValue) {
          return Container();
        }
        return Container(
            alignment: Alignment.center,
            width: windowW(),
            height: windowH(),
            color:Color.fromRGBO(0, 0, 0, alphaAnimation!.value),
            child: Container(
              height: (popH ?? defaultHeight) *scaleAnimation!.value, width: (popW ?? defaultWidth)
                *scaleAnimation!.value,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(defaultRadius),
                  color: Colors.white
              ),
              child: SingleChildScrollView(
                child: widget,
              ),
            )
        );
      });
    });
  }


}
