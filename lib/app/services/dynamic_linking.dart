import 'dart:developer';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class DynamicLinkService {
  Uri? previousLink;

  void listenForLinks(BuildContext context) {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      if (previousLink != dynamicLinkData.link) {
        try {
          previousLink = dynamicLinkData.link;
          GoRouter.of(context).pushNamed(dynamicLinkData.link.path);
        } catch (e) {
          log("====================\n error pushing route $e /n====================");
        }
      } else {
        log("====================\n pressedOnDuplicateLinks  /n====================");
      }
    });
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
      androidParameters: const AndroidParameters(
        // fallbackUrl: Uri.parse("https://play.google.com/store/apps/details?id=org.motb.mobile.museumofthebible"),
        packageName: "com.voostack.agilecardssprintplanning",
        minimumVersion: 1,
      ),
      iosParameters: const IOSParameters(
        // fallbackUrl: Uri.parse("https://apps.apple.com/us/app/museum-of-the-bible-discover/id1591251658"),
        bundleId: "com.voostack.agilecardssprintplanning",
        appStoreId: "1591251658",
        minimumVersion: "1.0.1",
      ),
      navigationInfoParameters: const NavigationInfoParameters(forcedRedirectEnabled: true),
      googleAnalyticsParameters: GoogleAnalyticsParameters(source: source, medium: medium, content: content),
      socialMetaTagParameters: socialMediaTitle == null ? null : SocialMetaTagParameters(title: socialMediaTitle, imageUrl: socialMediaImageUrl),
    );

    final link = await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);

    if (share == true) {
      Share.share('join with my session $link', subject: 'join my agile cards session');
    }
  }
}
