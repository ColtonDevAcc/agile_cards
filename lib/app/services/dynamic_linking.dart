import 'dart:developer';
import 'package:agile_cards/app/state/session/session_bloc.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class DynamicLinkService {
  Uri? previousLink;

  void listenForLinks(BuildContext context) {
    FirebaseDynamicLinks.instance.onLink.listen(
      (dynamicLinkData) {
        final uri = dynamicLinkData.link;
        if (uri != previousLink) {
          previousLink = uri;

          if (uri.pathSegments.contains('session')) {
            context.read<SessionBloc>().add(SessionJoined(uri.pathSegments.last));
            return;
          }

          context.go(uri.path);
        }
      },
      onError: (error) {
        log('Dynamic link error: $error');
      },
    );
  }

  Future<void> buildDynamicLink({
    String? source,
    String? medium,
    String? content,
    String? routeToContent,
    String? socialMediaTitle,
    Uri? socialMediaImageUrl,
    bool? share,
  }) async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://agilecards.page.link${routeToContent ?? "/"}"),
      uriPrefix: "https://agilecards.page.link",
      androidParameters: AndroidParameters(
        fallbackUrl: Uri.parse("https://apps.apple.com/us/app/agile-cards-sprint-planning/id1662639002"),
        packageName: "com.voostack.agilecardssprintplanning",
        minimumVersion: 1,
      ),
      iosParameters: IOSParameters(
        fallbackUrl: Uri.parse("https://apps.apple.com/us/app/agile-cards-sprint-planning/id1662639002"),
        bundleId: "com.voostack.agilecardssprintplanning",
        appStoreId: "1591251658",
        minimumVersion: "1.0.1",
      ),
      navigationInfoParameters: const NavigationInfoParameters(forcedRedirectEnabled: true),
      googleAnalyticsParameters: GoogleAnalyticsParameters(source: source, medium: medium, content: content),
      socialMetaTagParameters: socialMediaTitle == null
          ? null
          : SocialMetaTagParameters(
              title: socialMediaTitle,
              imageUrl: socialMediaImageUrl ??
                  Uri.parse(
                    "https://firebasestorage.googleapis.com/v0/b/agilecards-da16f.appspot.com/o/1_JPG.jpg?alt=media&token=141be1f9-20bc-4749-9808-5caca80dbe1c",
                  ),
            ),
    );

    final link = await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);

    if (share == true) {
      Share.share('join with my session $link', subject: 'join my agile cards session');
    }
  }

  Future<void> handleInitialLink(BuildContext context) async {
    final initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      log('====================\n initialLink ${initialLink.link.path} /n====================');
      if (initialLink.link.path == "/session") {
        final sessionId = initialLink.link.path.split('/session/')[1];
        log('====================\n sessionId $sessionId /n====================');
        // ignore: use_build_context_synchronously
        context.read<SessionBloc>().add(SessionJoined(sessionId));
        return;
      }

      // ignore: use_build_context_synchronously
      GoRouter.of(context).pushNamed(initialLink.link.path);
    }
  }
}
