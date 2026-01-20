// Legal screen with privacy policy and terms of service

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/generated/app_localizations.dart';

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.legal),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.privacyPolicy),
              Tab(text: l10n.termsOfService),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _PrivacyPolicyTab(),
            _TermsOfServiceTab(),
          ],
        ),
      ),
    );
  }
}

class _PrivacyPolicyTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.privacyPolicy,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.privacyPolicyContent,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 24),
          Center(
            child: OutlinedButton.icon(
              onPressed: () => _launchUrl('https://zeroclick.app/privacy'),
              icon: const Icon(Icons.open_in_new),
              label: Text(l10n.readFullVersion),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              l10n.lastUpdated('20 januari 2026'),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _TermsOfServiceTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.termsOfService,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.termsOfServiceContent,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 24),
          Center(
            child: OutlinedButton.icon(
              onPressed: () => _launchUrl('https://zeroclick.app/terms'),
              icon: const Icon(Icons.open_in_new),
              label: Text(l10n.readFullVersion),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              l10n.lastUpdated('20 januari 2026'),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

Future<void> _launchUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
