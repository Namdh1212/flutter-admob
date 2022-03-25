import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'AppLifecycleReactor.dart';
import 'AppOpenAdManager.dart';

/// Listens for app foreground events and shows app open ads.
class AdmodUtils {
  static AdRequest request = AdRequest();
  static InterstitialAd? _interstitialAd;
  static RewardedAd? _rewardedAd;
  static BannerAd? _anchoredAdaptiveAd;
  static late NativeAd adNative;

  static bool _isLoaded = false;
  static bool _isShowAds = false;
  static bool _isDebug = true;

  static var idTestInterstitialAd = "ca-app-pub-3940256099942544/1033173712";
  static var idTestRewardAd = "";
  static var idTestBannerAd = "";
  static var idTestNativeAd = "";

  static void configurationAdmob(
      {required bool isDebug, required bool isShowAds}) {
    request = AdRequest();
    configLoading();
    _isShowAds = isShowAds;
    _isDebug = isDebug;
  }

  static void loadAppOpenAd() {
    late AppLifecycleReactor _appLifecycleReactor;
    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    appOpenAdManager.isEnableAppOpenAd = true;
    _appLifecycleReactor =
        AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    _appLifecycleReactor.listenToAppStateChanges();
  }

  static void loadAndShowAdInterstitialWithCallback(
      {required String Androidid,
      required String IOSid,
      required bool enableLoadingDialog,
      required Function() onAdClosed,
      required Function() onAdFail}) {
    if (enableLoadingDialog) {
      EasyLoading.show(status: 'loading ads...');
    }

    if (_isDebug) {
      Androidid = idTestInterstitialAd;
      IOSid = idTestInterstitialAd;
    }

    InterstitialAd.load(
        adUnitId: Platform.isAndroid ? Androidid : IOSid,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _interstitialAd!.setImmersiveMode(true);
            _showInterstitialAd(onAdClosed: onAdClosed, onAdFail: onAdFail);
            EasyLoading.dismiss();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _interstitialAd = null;
            onAdFail();
            EasyLoading.dismiss();
          },
        ));
  }

  static void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/1033173712'
            : 'ca-app-pub-3940256099942544/4411468910',
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _interstitialAd = null;
            _createInterstitialAd();
          },
        ));
  }

  static void _showInterstitialAd(
      {required Function() onAdClosed, required Function() onAdFail}) {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        onAdClosed();
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        onAdFail();
        ad.dispose();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/5224354917'
            : 'ca-app-pub-3940256099942544/1712485313',
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            _rewardedAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            // _createRewardedAd();
          },
        ));
  }

  static void loadAndShowAdRewardWithCallback(
      {required String Androidid,
      required String IOSid,
      required bool enableLoadingDialog,
      required Function() onAdClosed,
      required Function() onUserEarned,
      required Function() onAdFail}) {
    if (enableLoadingDialog) {
      EasyLoading.show(status: 'loading ads...');
    }

    RewardedAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/5224354917'
            : 'ca-app-pub-3940256099942544/1712485313',
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            _rewardedAd = ad;
            _showRewardedAd(
                onAdClosed: onAdClosed,
                onUserEarned: onUserEarned,
                onAdFail: onAdFail);
            EasyLoading.dismiss();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            onAdFail();
            EasyLoading.dismiss();
          },
        ));
  }

  static void _showRewardedAd(
      {required Function() onAdClosed,
      required Function() onUserEarned,
      required Function() onAdFail}) {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        print('ad onAdShowedFullScreenContent.');
        onUserEarned();
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        onAdClosed();
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        onAdFail();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    });
    _rewardedAd = null;
  }

  static void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true;
  }

  static Future<void> loadAdBanner(
      {required String Androidid,
      required String IOSid,
      required Function() onAdLoaded,
      required Function() onAdFailed,
      var context}) async {
    await _anchoredAdaptiveAd?.dispose();
    // setState(() {
    _anchoredAdaptiveAd = null;
    _isLoaded = false;
    // });

    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).size.width.truncate());
    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    _anchoredAdaptiveAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716',
      size: size,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$ad loaded: ${ad.responseInfo}');
          _anchoredAdaptiveAd = ad as BannerAd;
          _isLoaded = true;
          onAdLoaded();
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Anchored adaptive banner failedToLoad: $error');
          ad.dispose();
          onAdFailed();
        },
      ),
    );
    return _anchoredAdaptiveAd!.load();
  }

  Widget getAdWidget() {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (_anchoredAdaptiveAd != null && _isLoaded) {
          return Container(
            color: Colors.green,
            width: _anchoredAdaptiveAd!.size.width.toDouble(),
            height: _anchoredAdaptiveAd!.size.height.toDouble(),
            child: AdWidget(ad: _anchoredAdaptiveAd!),
          );
        }
        return Container();
      },
    );
  }

  static bool isNativeAdLoaded = false;

  static void loadNativeAd(
      {required String Androidid,
      required String IOSid,
      required Function() onAdLoaded,
      required Function() onAdFailed,
      var context}) {
    adNative = NativeAd(
      adUnitId: Platform.isAndroid ? Androidid : IOSid,
      factoryId: 'listTile',
      request: AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          onAdLoaded();
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
          onAdFailed();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    adNative.load();
  }
}
