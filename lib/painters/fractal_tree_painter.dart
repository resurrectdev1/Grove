import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:grove/models/grove_models.dart';

class _TreeDNA {
  final double lean;
  final double spread;
  final double lengthBias;
  final double bushiness;
  final double forkHeight;
  final double leafScale;
  final double leafAspect;
  final double leafDensityBias;
  final int    archetype;

  const _TreeDNA({
    required this.lean,
    required this.spread,
    required this.lengthBias,
    required this.bushiness,
    required this.forkHeight,
    required this.leafScale,
    required this.leafAspect,
    required this.leafDensityBias,
    required this.archetype,
  });

  factory _TreeDNA.fromSeed(int seed) {
    double g(String key, double lo, double hi) {
      final h = ((seed.abs() + key.hashCode.abs()) % 1000) / 1000.0;
      return lo + h * (hi - lo);
    }
    final arch = ((seed.abs() + 'arch'.hashCode.abs()) % 4);
    final archSpreadBias   = const [0.0, 0.18, -0.14, 0.08][arch];
    final archLengthBias   = const [0.0, -0.08, 0.12, 0.04][arch];
    return _TreeDNA(
      lean:             g('lean',   -0.09, 0.09),
      spread:           g('spread',  0.80, 1.22) + archSpreadBias,
      lengthBias:       g('len',     0.88, 1.12) + archLengthBias,
      bushiness:        g('bush',    0.0,  1.0),
      forkHeight:       g('fork',    0.55, 0.80),
        leafScale:        g('lscale',  0.70, 1.30),
        leafAspect:       g('lasp',    0.75, 1.25),
        leafDensityBias:  g('ldens',   0.80, 1.20),
        archetype:        arch,
    );
  }
}

class FractalTreePainter extends CustomPainter {
  final GrowthStage stage;
  final Color       baseColor;
  final double      progress;
  final double      windPhase;
  final int         daysElapsed;
  final int         geneticSeed;
  final double      burstProgress;

  const FractalTreePainter({
    required this.stage,
    required this.baseColor,
    required this.progress,
    this.windPhase      = 0,
    this.daysElapsed    = 0,
    this.geneticSeed    = 0,
    this.burstProgress  = 0,
  });

  _TreeDNA get _dna => _TreeDNA.fromSeed(geneticSeed);

  int get _maxDepth {
    switch (stage) {
      case GrowthStage.seed:      return 0;
      case GrowthStage.sprout:    return 2;
      case GrowthStage.sapling:   return 3;
      case GrowthStage.youngTree: return 4;
      case GrowthStage.groveTree: return 5;
    }
  }

  double get _leafDensity {
    final raw = daysElapsed <= 7  ? 0.0
    : daysElapsed <= 35 ? ((daysElapsed - 7) / 28.0).clamp(0.0, 1.0)
    : 1.0;
    return (raw * _dna.leafDensityBias).clamp(0.0, 1.0);
  }

  Color get _activeColor => baseColor;

  Color get _barkColor {
    final hsl = HSLColor.fromColor(_activeColor);
    return hsl
    .withLightness((hsl.lightness * 0.45).clamp(0.0, 1.0))
    .withSaturation((hsl.saturation * 0.6).clamp(0.0, 1.0))
    .toColor();
  }

  Color get _leafColor {
    final hsl = HSLColor.fromColor(_activeColor);
    return hsl
    .withLightness((hsl.lightness * 1.15).clamp(0.0, 1.0))
    .withSaturation((hsl.saturation * 1.2).clamp(0.0, 1.0))
    .toColor();
  }

  Color get _leafHighlight {
    final hsl = HSLColor.fromColor(_activeColor);
    return hsl
    .withLightness((hsl.lightness * 1.40).clamp(0.0, 1.0))
    .withSaturation((hsl.saturation * 0.8).clamp(0.0, 1.0))
    .toColor();
  }

  Color get _sporeColor {
    final hsl = HSLColor.fromColor(_leafColor);
    final warmHue = (hsl.hue + 25) % 360;
    return hsl
    .withHue(warmHue)
    .withLightness((hsl.lightness * 1.35).clamp(0.0, 1.0))
    .withSaturation((hsl.saturation * 0.7).clamp(0.0, 1.0))
    .toColor();
  }

  double _genetic(String key) {
    final hash = ((geneticSeed.abs() + key.hashCode.abs()) % 1000);
    return (hash / 1000.0) * 0.2 - 0.1;
  }

  double _geneticPositive(String key, {double scale = 1.0}) {
    final hash = ((geneticSeed.abs() + key.hashCode.abs()) % 1000);
    return (hash / 1000.0) * scale;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (stage == GrowthStage.seed) {
      _drawSeed(canvas, size);
      if (burstProgress > 0) {
        final gx = size.width * 0.5;
        final gy = size.height * 0.93 - size.height * 0.18;
        _drawGrowthBurst(canvas, size, [Offset(gx, gy)]);
      }
      return;
    }

    final tipPositions = <Offset>[];
    _drawTree(canvas: canvas, size: size, color: _activeColor,
              maxDepth: _maxDepth, tipPositions: tipPositions);

    if (stage == GrowthStage.groveTree ||
      (stage == GrowthStage.youngTree && progress > 0.6)) {
      _drawSpores(canvas, size, tipPositions);
      }

      if (burstProgress > 0) {
        _drawGrowthBurst(canvas, size, tipPositions);
      }
  }

  void _drawTree({
    required Canvas  canvas,
    required Size    size,
    required Color   color,
    required int     maxDepth,
    required List<Offset> tipPositions,
  }) {
    final dna      = _dna;
    final gx       = size.width  * 0.5;
    final gy       = size.height * 0.93;
    final trunkLen = size.height * _lerpD(0.36, 0.58, progress)
    * dna.forkHeight * dna.lengthBias;
    final spread   = _lerpD(0.30, 0.52, progress) * dna.spread
    * (1.0 + _genetic('spread') * 0.5);
    final lenRatio = _lerpD(0.66, 0.73, progress) * dna.lengthBias
    * (1.0 + _genetic('ratio') * 0.3);
    final trunkW   = _lerpD(5.0, 9.0, progress);
    final rootAngle = -math.pi / 2 + dna.lean;

    if (maxDepth >= 2) {
      _drawRootFlare(canvas, Offset(gx, gy), trunkW, color);
    }
    _drawBranch(
      canvas: canvas, start: Offset(gx, gy),
      angle: rootAngle, length: trunkLen,
      depth: maxDepth, maxDepth: maxDepth,
      spreadAngle: spread, lengthRatio: lenRatio,
      strokeWidth: trunkW, depthFromTip: maxDepth,
      color: color, isMainTrunk: true,
      tipPositions: tipPositions,
    );
  }

  void _drawRootFlare(Canvas canvas, Offset base, double trunkWidth, Color color) {
    final barkC  = _barkColor;
    final flareR = trunkWidth * 1.8;
    canvas.drawOval(
      Rect.fromCenter(center: base.translate(0, 3),
      width: flareR * 3.2, height: flareR * 0.9),
      Paint()
      ..color = Colors.black.withValues(alpha: 0.18)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawOval(
      Rect.fromCenter(center: base, width: flareR * 2.4, height: flareR * 1.1),
      Paint()..color = barkC.withValues(alpha: 0.85)..style = PaintingStyle.fill,
    );
    final linePaint = Paint()
    ..color = _activeColor.withValues(alpha: 0.25)
    ..strokeWidth = 0.8
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 3; i++) {
      final ox = (i - 1) * flareR * 0.55;
      canvas.drawLine(
        Offset(base.dx + ox,       base.dy - flareR * 0.2),
        Offset(base.dx + ox * 1.4, base.dy + flareR * 0.3),
        linePaint,
      );
    }
  }

  void _drawBranch({
    required Canvas      canvas,
    required Offset      start,
    required double      angle,
    required double      length,
    required int         depth,
    required int         maxDepth,
    required double      spreadAngle,
    required double      lengthRatio,
    required double      strokeWidth,
    required int         depthFromTip,
    required Color       color,
    required List<Offset> tipPositions,
    bool                 isMainTrunk = false,
  }) {
    final dna = _dna;

    double windOffset = 0;
    if (depthFromTip <= 3 && windPhase > 0) {
      final windStrength = (1.0 - depthFromTip / 4.0) * 0.045;
      windOffset = math.sin(windPhase + depthFromTip * 0.9 +
      _genetic('wind') * math.pi) * windStrength;
    }

    final angleNoise     = _genetic('angle_$depth') * 0.28;
    final adjustedAngle  = angle + windOffset + angleNoise;

    final tipWidth = strokeWidth * 0.55;
    final tip = Offset(
      start.dx + length * math.cos(adjustedAngle),
      start.dy + length * math.sin(adjustedAngle),
    );

    final depthRatio    = maxDepth > 0 ? depth / maxDepth : 1.0;
    final branchOpacity = _lerpD(0.60, 0.98, depthRatio);
    final barkC         = _barkColor;

    if (strokeWidth > 1.5) {
      _drawTaperedBranch(canvas, start, tip, adjustedAngle,
                         strokeWidth, tipWidth, barkC, branchOpacity * 0.55);
      _drawTaperedBranch(canvas, start, tip, adjustedAngle,
                         strokeWidth * 0.70, tipWidth * 0.70,
                         color, branchOpacity * 0.80);
      canvas.drawLine(
        start.translate(math.cos(adjustedAngle + math.pi / 2) * strokeWidth * 0.18,
        math.sin(adjustedAngle + math.pi / 2) * strokeWidth * 0.18),
        tip.translate(  math.cos(adjustedAngle + math.pi / 2) * tipWidth   * 0.10,
        math.sin(adjustedAngle + math.pi / 2) * tipWidth   * 0.10),
        Paint()
        ..color = color.withValues(alpha: branchOpacity * 0.35)
        ..strokeWidth = strokeWidth * 0.22
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
      );
      if (strokeWidth > 3.5) {
        _drawBarkNicks(canvas, start, tip, strokeWidth, color, branchOpacity);
      }
    } else {
      canvas.drawLine(start, tip, Paint()
      ..color = color.withValues(alpha: branchOpacity)
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke);
    }

    if (depth == 0) {
      tipPositions.add(tip);
      final clusterSeed = geneticSeed + (angle * 100).toInt().abs() + depth * 7;
      _drawLeafCluster(canvas, tip, length, adjustedAngle, color, clusterSeed);
      return;
    }

    final childLen   = length * lengthRatio * (1.0 + _genetic('len_$depth') * 0.4);
    final widthRatio = 0.58 + dna.bushiness * 0.08;
    final childWidth = strokeWidth * widthRatio;
    final asym       = 0.04 + _genetic('asym') * 0.025;

    _drawBranch(
      canvas: canvas, start: tip,
      angle: adjustedAngle - spreadAngle,
      length: childLen * (1.0 - asym),
      depth: depth - 1, maxDepth: maxDepth,
      spreadAngle: spreadAngle * 0.90, lengthRatio: lengthRatio,
      strokeWidth: childWidth, depthFromTip: depthFromTip - 1,
      color: color, tipPositions: tipPositions,
    );
    _drawBranch(
      canvas: canvas, start: tip,
      angle: adjustedAngle + spreadAngle,
      length: childLen * (1.0 + asym),
      depth: depth - 1, maxDepth: maxDepth,
      spreadAngle: spreadAngle * 0.90, lengthRatio: lengthRatio,
      strokeWidth: childWidth, depthFromTip: depthFromTip - 1,
      color: color, tipPositions: tipPositions,
    );

    final midThreshold = 0.35 - dna.bushiness * 0.30;
    if (maxDepth >= 4 && depth == maxDepth - 1 &&
      _geneticPositive('mid_$depth') > midThreshold) {
      _drawBranch(
        canvas: canvas, start: tip,
        angle: adjustedAngle + _genetic('mid_$depth') * 0.35,
        length: childLen * 0.75,
        depth: depth - 2, maxDepth: maxDepth,
        spreadAngle: spreadAngle * 0.82, lengthRatio: lengthRatio,
        strokeWidth: childWidth * 0.75, depthFromTip: depthFromTip - 2,
        color: color, tipPositions: tipPositions,
      );
      }
  }

  void _drawTaperedBranch(Canvas canvas, Offset start, Offset tip,
                          double angle, double baseW, double tipW, Color color, double opacity) {
    final perp = angle + math.pi / 2;
    final cx   = math.cos(perp);
    final cy   = math.sin(perp);
    final path = Path()
    ..moveTo(start.dx + cx * baseW / 2, start.dy + cy * baseW / 2)
    ..lineTo(tip.dx   + cx * tipW  / 2, tip.dy   + cy * tipW  / 2)
    ..lineTo(tip.dx   - cx * tipW  / 2, tip.dy   - cy * tipW  / 2)
    ..lineTo(start.dx - cx * baseW / 2, start.dy - cy * baseW / 2)
    ..close();
    canvas.drawPath(path,
                    Paint()..color = color.withValues(alpha: opacity)..style = PaintingStyle.fill);
                          }

                          void _drawBarkNicks(Canvas canvas, Offset start, Offset tip,
                                              double strokeWidth, Color color, double opacity) {
                            final nickCount = 2 + (strokeWidth / 3).floor();
                            final nickPaint = Paint()
                            ..color = _barkColor.withValues(alpha: opacity * 0.45)
                            ..strokeWidth = 0.7
                            ..strokeCap = StrokeCap.round
                            ..style = PaintingStyle.stroke;
                            final dx = tip.dx - start.dx; final dy = tip.dy - start.dy;
                            final len = math.sqrt(dx * dx + dy * dy);
                            if (len < 1) return;
                            final nx = -dy / len; final ny = dx / len;
                            for (int k = 1; k <= nickCount; k++) {
                              final t  = k / (nickCount + 1.0);
                              final px = start.dx + dx * t; final py = start.dy + dy * t;
                              final half = strokeWidth * 0.30 * (0.7 + _geneticPositive('nick_$k'));
                              canvas.drawLine(
                                Offset(px + nx * half, py + ny * half),
                                Offset(px - nx * half, py - ny * half),
                                nickPaint,
                              );
                            }
                                              }

                                              void _drawLeafCluster(Canvas canvas, Offset tip, double branchLength,
                                                                    double branchAngle, Color color, [int? stableSeed]) {
                                                if (_leafDensity <= 0 && daysElapsed < 8) return;
                                                final dna  = _dna;
                                                final lc   = _leafColor;
                                                final lh   = _leafHighlight;

                                                final base = branchLength * 0.45 * dna.leafScale;

                                                final leafCount = (4 + _leafDensity * 5 * dna.leafDensityBias).floor();
                                                final rng = math.Random(stableSeed ?? geneticSeed);

                                                for (int pass = 0; pass < 2; pass++) {
                                                  final isBack = pass == 0;
                                                  for (int i = 0; i < (isBack ? leafCount ~/ 2 : leafCount); i++) {
                                                    final angleOff  = (rng.nextDouble() - 0.5) * 2.2;
                                                    final distOff   = rng.nextDouble() * base * 0.55;
                                                    final leafAngle = branchAngle + angleOff;
                                                    final lx = tip.dx + math.cos(leafAngle) * distOff;
                                                    final ly = tip.dy + math.sin(leafAngle) * distOff;
                                                    final leafSize = (branchLength * 0.22 + rng.nextDouble() * branchLength * 0.07
                                                    + _leafDensity * branchLength * 0.03)
                                                    .clamp(4.0, 18.0) * dna.leafScale;
                                                    final rotation   = branchAngle + angleOff * 0.6 + rng.nextDouble() * 0.4;
                                                    final distFactor = 1.0 - (distOff / (base * 0.55)).clamp(0.0, 0.35);
                                                    final sizeMulti  = isBack ? 0.72 : 1.0;
                                                    final leafOpacity = (isBack ? 0.28 : 0.52 + _leafDensity * 0.22)
                                                    * distFactor;
                                                    _drawSingleLeaf(canvas, Offset(lx, ly), leafSize * sizeMulti,
                                                    rotation, lc, lh, leafOpacity, dna.leafAspect);
                                                  }
                                                }
                                                if (_leafDensity > 0.5) _drawLeafFlecks(canvas, tip, base * 0.6, color);
                                                                    }

                                                                    void _drawSingleLeaf(Canvas canvas, Offset center, double size, double angle,
                                                                                         Color leafCol, Color highlight, double opacity, [double aspect = 1.0]) {
                                                                      canvas.save();
                                                                      canvas.translate(center.dx, center.dy);
                                                                      canvas.rotate(angle);

                                                                      final w = aspect;
                                                                      final leafPath = Path()
                                                                      ..moveTo(0, -size)
                                                                      ..cubicTo( size * 0.55 * w, -size * 0.55,  size * 0.62 * w,  size * 0.35, 0,  size * 0.45)
                                                                      ..cubicTo(-size * 0.62 * w,  size * 0.35, -size * 0.55 * w, -size * 0.55, 0, -size)
                                                                      ..close();

                                                                      canvas.drawPath(leafPath,
                                                                                      Paint()..color = leafCol.withValues(alpha: opacity)..style = PaintingStyle.fill);

                                                                      final highlightPath = Path()
                                                                      ..moveTo(0, -size)
                                                                      ..cubicTo( size * 0.28 * w, -size * 0.55,  size * 0.22 * w, -size * 0.05, 0, -size * 0.05)
                                                                      ..cubicTo(-size * 0.22 * w, -size * 0.05, -size * 0.28 * w, -size * 0.55, 0, -size)
                                                                      ..close();
                                                                      canvas.drawPath(highlightPath,
                                                                                      Paint()..color = highlight.withValues(alpha: opacity * 0.28)..style = PaintingStyle.fill);

                                                                      canvas.drawLine(Offset(0, -size * 0.85), Offset(0, size * 0.35),
                                                                      Paint()
                                                                      ..color = leafCol.withValues(alpha: opacity * 0.55)
                                                                      ..strokeWidth = size * 0.07
                                                                      ..strokeCap = StrokeCap.round
                                                                      ..style = PaintingStyle.stroke);

                                                                      final veinPaint = Paint()
                                                                      ..color = leafCol.withValues(alpha: opacity * 0.30)
                                                                      ..strokeWidth = size * 0.04
                                                                      ..strokeCap = StrokeCap.round
                                                                      ..style = PaintingStyle.stroke;
                                                                      for (final veinT in [0.25, 0.55]) {
                                                                        final vy = -size * (0.85 - veinT * 1.2);
                                                                        final vx =  size * 0.42 * veinT * w;
                                                                        canvas.drawLine(Offset(0, vy), Offset( vx, vy + size * 0.18), veinPaint);
                                                                        canvas.drawLine(Offset(0, vy), Offset(-vx, vy + size * 0.18), veinPaint);
                                                                      }

                                                                      canvas.drawPath(leafPath,
                                                                                      Paint()
                                                                                      ..color = leafCol.withValues(alpha: opacity * 0.40)
                                                                                      ..strokeWidth = size * 0.055
                                                                                      ..style = PaintingStyle.stroke);
                                                                      canvas.restore();
                                                                                         }

                                                                                         void _drawLeafFlecks(Canvas canvas, Offset tip, double radius, Color color) {
                                                                                           final fleckCount = (3 + _leafDensity * 4).floor();
                                                                                           final paint      = Paint()..style = PaintingStyle.fill;
                                                                                           final rng        = math.Random(geneticSeed + tip.dx.toInt() * 7);
                                                                                           for (int i = 0; i < fleckCount; i++) {
                                                                                             final a  = rng.nextDouble() * math.pi * 2;
                                                                                             final d  = rng.nextDouble() * radius * 0.85;
                                                                                             final fx = tip.dx + math.cos(a) * d;
                                                                                             final fy = tip.dy + math.sin(a) * d;
                                                                                             final fr = 1.0 + rng.nextDouble() * 1.2;
                                                                                             paint.color = _sporeColor.withValues(alpha: 0.50 + _leafDensity * 0.35);
                                                                                             canvas.drawCircle(Offset(fx, fy), fr, paint);
                                                                                           }
                                                                                         }

                                                                                         void _drawSpores(Canvas canvas, Size size, List<Offset> tips) {
                                                                                           if (tips.isEmpty) return;
                                                                                           final paint = Paint()..style = PaintingStyle.fill;

                                                                                           final mossBase      = _barkColor;
                                                                                           final mossHighlight = _leafColor;

                                                                                           final breathAlpha = ((math.sin(windPhase * 0.4) * 0.5 +
                                                                                           math.sin(windPhase * 0.17) * 0.15 + 0.65))
                                                                                           .clamp(0.25, 1.0);

                                                                                           final trunkX  = size.width  * 0.5;
                                                                                           final groundY = size.height * 0.93;
                                                                                           final canopyY = tips.fold(groundY, (double lo, Offset t) => math.min(lo, t.dy));
                                                                                           final treeH   = (groundY - canopyY).clamp(40.0, size.height);

                                                                                           const fadeInEnd    = 0.18;
                                                                                           const fadeOutStart = 0.75;

                                                                                           final largeCount = 6 + (geneticSeed.abs() % 5);
                                                                                           for (int i = 0; i < largeCount; i++) {
                                                                                             final seedOff = (geneticSeed.abs() + i * 73) % 100;
                                                                                             final speed   = 0.18 + (seedOff % 6) * 0.09;
                                                                                             final phase   = (windPhase * speed + seedOff * 0.063) % (math.pi * 2);
                                                                                             final lifetime = phase / (math.pi * 2);

                                                                                             final easedLife = lifetime < 0.5
                                                                                             ? 2 * lifetime * lifetime
                                                                                             : 1 - math.pow(-2 * lifetime + 2, 2) / 2;
                                                                                             final py = (groundY + 8) - easedLife * treeH * 1.25;

                                                                                             if (py < -30 || py > size.height + 10) continue;

                                                                                             final heightRatio = (groundY - py) / treeH;
                                                                                             final fadeIn  = (heightRatio / fadeInEnd).clamp(0.0, 1.0);
                                                                                             final fadeOut = ((1.0 - heightRatio) / (1.0 - fadeOutStart)).clamp(0.0, 1.0);
                                                                                             final opacity = (0.70 * fadeIn * fadeOut * breathAlpha).clamp(0.0, 1.0);
                                                                                             if (opacity < 0.01) continue;

                                                                                             final clampedHR   = heightRatio.clamp(0.0, 1.0);
                                                                                             final orbitRadius = (28.0 + (seedOff % 4) * 10.0) * (1.0 - clampedHR * 0.65);
                                                                                             final swirl = windPhase * (0.55 + (seedOff % 3) * 0.18)
                                                                                             + seedOff * 0.44
                                                                                             + clampedHR * math.pi * 1.8;
                                                                                             final px = (trunkX + math.cos(swirl) * orbitRadius)
                                                                                             .clamp(4.0, size.width - 4.0);

                                                                                             final radius = 2.0 + (seedOff % 3) * 0.8 + clampedHR * 1.2;

                                                                                             for (int t = 3; t >= 1; t--) {
                                                                                               final tPhase  = ((phase - t * 0.055) % (math.pi * 2)).clamp(0.0, math.pi * 2);
                                                                                               final tLife   = tPhase / (math.pi * 2);
                                                                                               final tEased  = tLife < 0.5 ? 2 * tLife * tLife : 1 - math.pow(-2 * tLife + 2, 2) / 2;
                                                                                               final tPy     = (groundY + 8) - tEased * treeH * 1.25;
                                                                                               final tHR     = ((groundY - tPy) / treeH).clamp(0.0, 1.0);
                                                                                               final tFadeIn  = (tHR / fadeInEnd).clamp(0.0, 1.0);
                                                                                               final tFadeOut = ((1.0 - tHR) / (1.0 - fadeOutStart)).clamp(0.0, 1.0);
                                                                                               final tOpacity = opacity * tFadeIn * tFadeOut * (1.0 - t * 0.28);
                                                                                               if (tOpacity < 0.01) continue;
                                                                                               final tOrbit = (28.0 + (seedOff % 4) * 10.0) * (1.0 - tHR * 0.65);
                                                                                               final tSwirl = windPhase * (0.55 + (seedOff % 3) * 0.18)
                                                                                               + seedOff * 0.44 + tHR * math.pi * 1.8
                                                                                               - t * 0.055 * (0.55 + (seedOff % 3) * 0.18);
                                                                                               final tPx = (trunkX + math.cos(tSwirl) * tOrbit).clamp(4.0, size.width - 4.0);
                                                                                               paint.color = mossBase.withValues(alpha: tOpacity * 0.45);
                                                                                               canvas.drawCircle(Offset(tPx, tPy), radius * (1.0 - t * 0.22), paint);
                                                                                             }

                                                                                             paint.color = mossBase.withValues(alpha: opacity * 0.12);
                                                                                             canvas.drawCircle(Offset(px, py), radius * (2.8 + (seedOff % 4) * 0.5), paint);

                                                                                             _drawMossFragment(canvas, Offset(px, py), radius * 1.8,
                                                                                             swirl, mossBase, mossHighlight, opacity, seedOff);
                                                                                           }

                                                                                           final dustCount = 14 + (geneticSeed.abs() % 8);
                                                                                           for (int i = 0; i < dustCount; i++) {
                                                                                             final seedOff  = (geneticSeed.abs() + i * 37 + 500) % 100;
                                                                                             final speed    = 0.5 + (seedOff % 7) * 0.14;
                                                                                             final phase    = (windPhase * speed + seedOff * 0.11) % (math.pi * 2);
                                                                                             final lifetime = phase / (math.pi * 2);

                                                                                             final spawnX = trunkX + ((seedOff % 21) - 10) * 3.5;
                                                                                             final driftX = math.sin(phase * 2.7 + seedOff * 0.09) * 22.0
                                                                                             + math.cos(phase * 1.3 + seedOff * 0.05) * 8.0;
                                                                                             final px = (spawnX + driftX).clamp(4.0, size.width - 4.0);
                                                                                             final py = (groundY + 8) - lifetime * treeH * 1.25;

                                                                                             if (py < -10 || py > size.height + 10) continue;

                                                                                             final heightRatio = (groundY - py) / treeH;
                                                                                             final fadeIn  = (heightRatio / fadeInEnd).clamp(0.0, 1.0);
                                                                                             final fadeOut = ((1.0 - heightRatio) / (1.0 - fadeOutStart)).clamp(0.0, 1.0);
                                                                                             final opacity = (0.55 * fadeIn * fadeOut * breathAlpha).clamp(0.0, 1.0);
                                                                                             if (opacity < 0.01) continue;

                                                                                             final r = 1.0 + (seedOff % 2) * 0.5;
                                                                                             paint.color = mossBase.withValues(alpha: opacity);
                                                                                             canvas.drawCircle(Offset(px, py), r, paint);
                                                                                             paint.color = mossHighlight.withValues(alpha: opacity * 0.18);
                                                                                             canvas.drawCircle(Offset(px, py), r * 2.6, paint);
                                                                                           }
                                                                                         }

                                                                                         void _drawMossFragment(Canvas canvas, Offset center, double size,
                                                                                                                double angle, Color base, Color highlight, double opacity, int seedOff) {
                                                                                           canvas.save();
                                                                                           canvas.translate(center.dx, center.dy);
                                                                                           canvas.rotate(angle);

                                                                                           final paint = Paint()..style = PaintingStyle.fill;

                                                                                           final blobCount = 4 + (seedOff % 2);
                                                                                           for (int b = 0; b < blobCount; b++) {
                                                                                             final bAngle  = b * math.pi * 2 / blobCount + seedOff * 0.11;
                                                                                             final bDist   = size * (0.18 + (seedOff * (b + 1) % 7) * 0.055);
                                                                                             final bRadius = size * (0.42 + (seedOff * (b + 3) % 5) * 0.06);
                                                                                             final bx = math.cos(bAngle) * bDist;
                                                                                             final by = math.sin(bAngle) * bDist;
                                                                                             paint.color = base.withValues(alpha: opacity * 0.82);
                                                                                             canvas.drawCircle(Offset(bx, by), bRadius, paint);
                                                                                             paint.color = highlight.withValues(alpha: opacity * 0.22);
                                                                                             canvas.drawCircle(Offset(bx - bRadius * 0.18, by - bRadius * 0.18),
                                                                                             bRadius * 0.55, paint);
                                                                                           }

                                                                                           paint.color = highlight.withValues(alpha: opacity * 0.35);
                                                                                           canvas.drawCircle(Offset.zero, size * 0.18, paint);

                                                                                           canvas.restore();
                                                                                                                }



                                                                                                                void _drawGrowthBurst(Canvas canvas, Size size, List<Offset> tips) {
                                                                                                                  if (tips.isEmpty) return;
                                                                                                                  final t = burstProgress.clamp(0.0, 1.0);

                                                                                                                  final eased = 1.0 - math.pow(1.0 - t, 3).toDouble();

                                                                                                                  final envelope = t < 0.12
                                                                                                                  ? (t / 0.12)
                                                                                                                  : t > 0.70
                                                                                                                  ? (1.0 - (t - 0.70) / 0.30).clamp(0.0, 1.0)
                                                                                                                  : 1.0;
                                                                                                                  if (envelope <= 0.0) return;

                                                                                                                  final lc = _leafColor;
                                                                                                                  final lh = _leafHighlight;
                                                                                                                  final sc = _sporeColor;
                                                                                                                  final paint = Paint()..style = PaintingStyle.fill;

                                                                                                                  for (int ti = 0; ti < tips.length; ti++) {
                                                                                                                    final tip = tips[ti];
                                                                                                                    final particleCount = 5 + (geneticSeed.abs() + ti * 31) % 4;
                                                                                                                    final rng = math.Random(geneticSeed + ti * 97);

                                                                                                                    for (int i = 0; i < particleCount; i++) {
                                                                                                                      final seedOff   = (geneticSeed.abs() + ti * 53 + i * 17) % 100;
                                                                                                                      final baseAngle = -math.pi / 2 + (rng.nextDouble() - 0.5) * math.pi * 1.1;
                                                                                                                      final dist      = (18.0 + seedOff * 0.6) * eased;
                                                                                                                      final drift     = math.sin(eased * math.pi) * 6.0 * (i.isEven ? 1 : -1);

                                                                                                                      final px = tip.dx + math.cos(baseAngle) * dist + drift * 0.3;
                                                                                                                      final py = tip.dy + math.sin(baseAngle) * dist - eased * (10.0 + seedOff * 0.25);

                                                                                                                      final particleFade = (1.0 - eased * 0.55).clamp(0.0, 1.0);
                                                                                                                      final opacity = (particleFade * envelope).clamp(0.0, 1.0);
                                                                                                                      if (opacity < 0.02) continue;

                                                                                                                      final leafSz = (4.0 + (seedOff % 5) * 0.9) * (0.6 + eased * 0.4);
                                                                                                                      final rotation = baseAngle + eased * math.pi * (i.isEven ? 1.4 : -1.4);

                                                                                                                      _drawSingleLeaf(canvas, Offset(px, py), leafSz, rotation,
                                                                                                                      lc, lh, opacity * 0.85, _dna.leafAspect);

                                                                                                                      paint.color = sc.withValues(alpha: opacity * 0.55);
                                                                                                                      canvas.drawCircle(Offset(px, py), leafSz * 0.22, paint);
                                                                                                                    }

                                                                                                                    final glowOpacity = (0.35 * (1.0 - eased) * envelope).clamp(0.0, 1.0);
                                                                                                                    if (glowOpacity > 0.02) {
                                                                                                                      paint.color = lh.withValues(alpha: glowOpacity);
                                                                                                                      canvas.drawCircle(tip, 10.0 + eased * 6.0, paint);
                                                                                                                    }
                                                                                                                  }
                                                                                                                }

                                                                                                                void _drawSeed(Canvas canvas, Size size) {
                                                                                                                  final gx = size.width  * 0.5;
                                                                                                                  final gy = size.height * 0.93;
                                                                                                                  final ac = _activeColor;
                                                                                                                  final bc = _barkColor;

                                                                                                                  const sproutStart = 0.35;
                                                                                                                  const sproutEnd   = 0.75;
                                                                                                                  final sproutMix = progress <= sproutStart
                                                                                                                  ? 0.0
                                                                                                                  : progress >= sproutEnd
                                                                                                                  ? 1.0
                                                                                                                  : (progress - sproutStart) / (sproutEnd - sproutStart);
                                                                                                                  final seedMix = 1.0 - sproutMix;

                                                                                                                  if (seedMix > 0) {
                                                                                                                    final r = size.width * 0.085 * (0.55 + seedMix * 0.45);
                                                                                                                    final cx = gx;
                                                                                                                    final cy = gy - r * 0.55;

                                                                                                                    canvas.drawOval(
                                                                                                                      Rect.fromCenter(center: Offset(cx, gy), width: r * 2.6, height: r * 0.6),
                                                                                                                      Paint()
                                                                                                                      ..color = Colors.black.withValues(alpha: 0.15 * seedMix)
                                                                                                                      ..style = PaintingStyle.fill
                                                                                                                      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
                                                                                                                    );

                                                                                                                    final seedPath = Path()
                                                                                                                    ..moveTo(cx, cy - r * 0.95)
                                                                                                                    ..cubicTo(cx + r * 0.85, cy - r * 0.55, cx + r * 0.90, cy + r * 0.40, cx, cy + r * 0.60)
                                                                                                                    ..cubicTo(cx - r * 0.90, cy + r * 0.40, cx - r * 0.85, cy - r * 0.55, cx, cy - r * 0.95)
                                                                                                                    ..close();
                                                                                                                    canvas.drawPath(seedPath,
                                                                                                                                    Paint()..color = ac.withValues(alpha: 0.75 * seedMix)..style = PaintingStyle.fill);

                                                                                                                    final sheenPath = Path()
                                                                                                                    ..moveTo(cx, cy - r * 0.90)
                                                                                                                    ..cubicTo(cx + r * 0.30, cy - r * 0.70, cx + r * 0.28, cy - r * 0.10, cx, cy - r * 0.05)
                                                                                                                    ..cubicTo(cx - r * 0.28, cy - r * 0.10, cx - r * 0.30, cy - r * 0.70, cx, cy - r * 0.90)
                                                                                                                    ..close();
                                                                                                                    canvas.drawPath(sheenPath,
                                                                                                                                    Paint()..color = ac.withValues(alpha: 0.30 * seedMix)..style = PaintingStyle.fill);

                                                                                                                    canvas.drawPath(seedPath,
                                                                                                                                    Paint()
                                                                                                                                    ..color = bc.withValues(alpha: 0.70 * seedMix)
                                                                                                                                    ..strokeWidth = r * 0.10
                                                                                                                                    ..style = PaintingStyle.stroke);
                                                                                                                    canvas.drawLine(
                                                                                                                      Offset(cx, cy - r * 0.80), Offset(cx, cy + r * 0.50),
                                                                                                                      Paint()
                                                                                                                      ..color = bc.withValues(alpha: 0.50 * seedMix)
                                                                                                                      ..strokeWidth = r * 0.06
                                                                                                                      ..strokeCap = StrokeCap.round
                                                                                                                      ..style = PaintingStyle.stroke,
                                                                                                                    );
                                                                                                                  }

                                                                                                                  if (sproutMix > 0) {
                                                                                                                    final growth   = (0.25 + sproutMix * 0.75).clamp(0.0, 1.0);
                                                                                                                    final sproutH  = size.height * 0.18 * growth;
                                                                                                                    final stemBase = Offset(gx, gy);
                                                                                                                    final stemTip  = Offset(gx, gy - sproutH);

                                                                                                                    canvas.drawOval(
                                                                                                                      Rect.fromCenter(center: stemBase.translate(0, 2), width: sproutH * 0.55, height: sproutH * 0.10),
                                                                                                                      Paint()
                                                                                                                      ..color = Colors.black.withValues(alpha: 0.12 * sproutMix)
                                                                                                                      ..style = PaintingStyle.fill
                                                                                                                      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
                                                                                                                    );

                                                                                                                    final stemPath = Path()
                                                                                                                    ..moveTo(stemBase.dx, stemBase.dy)
                                                                                                                    ..quadraticBezierTo(stemBase.dx + sproutH * 0.10, stemBase.dy - sproutH * 0.5, stemTip.dx, stemTip.dy);
                                                                                                                    canvas.drawPath(stemPath,
                                                                                                                                    Paint()
                                                                                                                                    ..color = ac.withValues(alpha: 0.85 * sproutMix)
                                                                                                                                    ..strokeWidth = size.width * 0.016
                                                                                                                                    ..strokeCap = StrokeCap.round
                                                                                                                                    ..style = PaintingStyle.stroke);

                                                                                                                    final leafGrow = sproutMix > 0.35 ? ((sproutMix - 0.35) / 0.65).clamp(0.0, 1.0) : 0.0;
                                                                                                                    if (leafGrow > 0) {
                                                                                                                      final leafSz = sproutH * 0.32 * leafGrow;
                                                                                                                      _drawSingleLeaf(canvas,
                                                                                                                                      Offset(stemTip.dx - leafSz * 0.8, stemTip.dy + leafSz * 0.3),
                                                                                                                                      leafSz, -math.pi * 0.35, _leafColor, _leafHighlight,
                                                                                                                                      0.80 * leafGrow * sproutMix, _dna.leafAspect);
                                                                                                                      _drawSingleLeaf(canvas,
                                                                                                                                      Offset(stemTip.dx + leafSz * 0.8, stemTip.dy + leafSz * 0.3),
                                                                                                                                      leafSz,  math.pi * 0.35, _leafColor, _leafHighlight,
                                                                                                                                      0.80 * leafGrow * sproutMix, _dna.leafAspect);
                                                                                                                    }
                                                                                                                  }
                                                                                                                }

                                                                                                                static double _lerpD(double a, double b, double t) => a + (b - a) * t;

                                                                                                                @override
                                                                                                                bool shouldRepaint(FractalTreePainter old) =>
                                                                                                                old.stage        != stage        || old.baseColor   != baseColor   ||
                                                                                                                old.progress     != progress     || old.windPhase   != windPhase   ||
                                                                                                                old.daysElapsed  != daysElapsed  || old.geneticSeed != geneticSeed ||
                                                                                                                old.burstProgress != burstProgress;
}
