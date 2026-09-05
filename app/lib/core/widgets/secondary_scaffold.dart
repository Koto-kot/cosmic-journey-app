import 'package:flutter/material.dart';

import '../entitlement/entitlement.dart';
import '../theme_tokens.dart';
import 'ad_slot.dart';
import 'cosmic_backdrop.dart';

class SecondaryScaffold extends StatelessWidget {
  const SecondaryScaffold({
    super.key,
    required this.title,
    required this.child,
    this.entitlement,
    this.adPlacement,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Entitlement? entitlement;
  final String? adPlacement;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CosmicTokens.background,
      body: CosmicBackdrop(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                  ),
                  const Spacer(),
                  ?trailing,
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(child: child),
              if (entitlement != null && adPlacement != null)
                AdSlot(entitlement: entitlement!, placement: adPlacement!),
            ],
          ),
        ),
      ),
    );
  }
}
