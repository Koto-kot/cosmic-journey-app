import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import 'earth_fallback.dart';

Widget buildEarthCanvasEmbed({
  required double size,
  required bool reducedMotion,
}) {
  return EarthCanvasEmbed(size: size, reducedMotion: reducedMotion);
}

class EarthCanvasEmbed extends StatefulWidget {
  const EarthCanvasEmbed({
    super.key,
    required this.size,
    required this.reducedMotion,
  });

  final double size;
  final bool reducedMotion;

  @override
  State<EarthCanvasEmbed> createState() => _EarthCanvasEmbedState();
}

class _EarthCanvasEmbedState extends State<EarthCanvasEmbed> {
  web.HTMLElement? _host;
  var _failed = false;

  @override
  void didUpdateWidget(EarthCanvasEmbed oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reducedMotion != widget.reducedMotion) {
      _mount();
    }
  }

  @override
  void dispose() {
    final host = _host;
    if (host != null) {
      _unmount(host);
    }
    super.dispose();
  }

  void _mount() {
    final host = _host;
    if (host == null || _failed) {
      return;
    }
    try {
      _ensureTransparentHost(host);
      if (!globalContext.has('CosmicEarthCanvas')) {
        throw StateError('CosmicEarthCanvas script missing');
      }
      final api =
          globalContext.getProperty('CosmicEarthCanvas'.toJS) as JSObject;
      final mount = api.getProperty('mountEarthCanvas'.toJS) as JSFunction;
      final options = {'reducedMotion': widget.reducedMotion}.jsify()!;
      mount.callAsFunction(api, host, options);
    } catch (_) {
      if (mounted) {
        setState(() => _failed = true);
      } else {
        _failed = true;
      }
    }
  }

  void _unmount(web.HTMLElement host) {
    try {
      if (!globalContext.has('CosmicEarthCanvas')) {
        return;
      }
      final api =
          globalContext.getProperty('CosmicEarthCanvas'.toJS) as JSObject;
      final unmount = api.getProperty('unmountEarthCanvas'.toJS) as JSFunction;
      unmount.callAsFunction(api, host);
    } catch (_) {
      // Host is going away; ignore a missing runtime.
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return EarthFallbackGlobe(
        size: widget.size,
        reducedMotion: widget.reducedMotion,
      );
    }
    return IgnorePointer(
      child: HtmlElementView.fromTagName(
        tagName: 'div',
        onElementCreated: (element) {
          final host = element as web.HTMLElement;
          _host = host;
          host.className = 'cosmic-earth-host';
          _mount();
        },
      ),
    );
  }
}

void _ensureTransparentHost(web.HTMLElement host) {
  host.style
    ..setProperty('background', 'transparent')
    ..setProperty('pointer-events', 'none')
    ..setProperty('touch-action', 'none')
    ..setProperty('width', '100%')
    ..setProperty('height', '100%')
    ..setProperty('overflow', 'hidden');
  host.setAttribute('aria-hidden', 'true');
}
