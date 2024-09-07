import 'package:flutter/widgets.dart';

final class BannerHost extends StatefulWidget {
  const BannerHost({
    super.key,
    required this.hideBanner,
    required this.banner,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.fastOutSlowIn,
  });

  final bool hideBanner;
  final Widget banner;
  final Widget child;
  final Duration? duration;
  final Curve curve;

  @override
  State<BannerHost> createState() => BannerHostState();
}

final class BannerHostState extends State<BannerHost>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      value: widget.hideBanner ? 0.0 : 1.0,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );
  }

  @override
  void didUpdateWidget(covariant BannerHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hideBanner != widget.hideBanner) {
      if (widget.hideBanner) {
        //hide banner
        Future.delayed(const Duration(seconds: 1))
            .whenComplete(() => _controller.reverse());
        // _controller.reverse();
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomMultiChildLayout(
        delegate: _BannerHostDelegate(_animation),
        children: [
          LayoutId(
            id: _BannerHostWidgetId.child,
            child: widget.child,
          ),
          LayoutId(
            id: _BannerHostWidgetId.banner,
            child: widget.banner,
          ),
        ],
      ),
    );
  }
}

enum _BannerHostWidgetId { child, banner }

final class _BannerHostDelegate extends MultiChildLayoutDelegate {
  _BannerHostDelegate(this._animation) : super(relayout: _animation);

  final Animation<double> _animation;

  @override
  void performLayout(Size size) {
    layoutChild(_BannerHostWidgetId.child, BoxConstraints.tight(size));

    final bannerSize = layoutChild(
      _BannerHostWidgetId.banner,
      BoxConstraints.tightFor(width: size.width),
    );
    // positionChild(_BannerHostWidgetId.child,
    //     Offset(0.0, 0.0 - (_animation.value * bannerSize.height))); //for youtube style but in that case the BannerHost rapper should be in side material or Cupertino APP say widget app because here child size is tight for height
    positionChild(_BannerHostWidgetId.child, Offset.zero);
    positionChild(
      _BannerHostWidgetId.banner,
      Offset(
        0.0,
        size.height - (_animation.value * bannerSize.height),
      ),
    );
  }

  @override
  bool shouldRelayout(covariant _BannerHostDelegate oldDelegate) {
    return _animation != oldDelegate._animation;
  }
}