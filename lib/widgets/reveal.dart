import 'package:flutter/widgets.dart';
import 'package:grove/theme/motion.dart';

class Reveal extends StatefulWidget {
  final Widget child;
  final Duration delay;

  final bool animate;

  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.animate = true,
  });

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _t;

  @override
  void initState() {
    super.initState();
    final reduceMotion = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    final play = widget.animate && !reduceMotion;
    final total = Motion.slow + widget.delay;
    _controller = AnimationController(
      vsync: this,
      duration: total,
      value: play ? 0 : 1,
    );
    final begin = widget.delay.inMilliseconds / total.inMilliseconds;
    _t = CurvedAnimation(
      parent: _controller,
      curve: Interval(begin, 1, curve: Motion.standard),
    );
    if (play) _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _t,
    child: ScaleTransition(
      scale: Tween<double>(begin: 0.94, end: 1).animate(_t),
      child: widget.child,
    ),
  );
}

class EntranceTracker {
  static const int _maxStaggered = 8;
  static const int _stepMs = 45;

  static const Duration _window = Duration(milliseconds: 800);

  final Set<String> _known = {};
  final Map<String, (Duration, DateTime)> _pending = {};

  void sync(Iterable<String> ids) {
    final list = ids.toList();
    final fresh = list.where((id) => !_known.contains(id)).toList();
    final until = DateTime.now().add(_window);
    for (var i = 0; i < fresh.length && i < _maxStaggered; i++) {
      final delay = fresh.length > 1
          ? Duration(milliseconds: _stepMs * i)
          : Duration.zero;
      _pending[fresh[i]] = (delay, until);
    }
    _known
      ..clear()
      ..addAll(list);
    _pending.removeWhere((id, _) => !_known.contains(id));
  }

  void reset() {
    _known.clear();
    _pending.clear();
  }

  Duration? take(String id) {
    final entry = _pending.remove(id);
    if (entry == null) return null;
    return DateTime.now().isAfter(entry.$2) ? null : entry.$1;
  }
}

class StaggeredEntrance extends StatefulWidget {
  final EntranceTracker tracker;
  final String id;
  final Widget child;

  const StaggeredEntrance({
    super.key,
    required this.tracker,
    required this.id,
    required this.child,
  });

  @override
  State<StaggeredEntrance> createState() => _StaggeredEntranceState();
}

class _StaggeredEntranceState extends State<StaggeredEntrance> {
  late final Duration? _delay;

  @override
  void initState() {
    super.initState();
    _delay = widget.tracker.take(widget.id);
  }

  @override
  Widget build(BuildContext context) => Reveal(
    animate: _delay != null,
    delay: _delay ?? Duration.zero,
    child: widget.child,
  );
}
