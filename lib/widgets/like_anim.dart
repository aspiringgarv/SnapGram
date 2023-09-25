import 'package:flutter/material.dart';
class LikeAnimation extends StatefulWidget {
  final Widget child;
  final bool animate;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool smallike;
  const LikeAnimation({super.key,required this.animate,this.duration = const Duration(milliseconds: 150),required this.child,required this.onEnd,this.smallike = false});

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}
class _LikeAnimationState extends State<LikeAnimation> with SingleTickerProviderStateMixin {
 late AnimationController animationController;
 late Animation<double> scale;
 @override
 void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(vsync: this,duration: widget.duration~/2);
    scale = Tween<double>(begin: 1,end: 1.2).animate(animationController);
  }
  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if(widget.animate!=oldWidget.animate){
      startAnimation();
    }
  }
  startAnimation()async{
   if(widget.animate||widget.smallike){
     await animationController.forward();
     await animationController.reverse();
     await Future.delayed(const Duration(milliseconds: 250));
     if(widget.onEnd!=null){
       widget.onEnd!();
     }
   }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: scale,
    child: widget.child,
    );
  }
}
