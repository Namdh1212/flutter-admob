import 'dart:io' show Platform;

import 'package:admob_lib_flutter/AdmodUtils.dart';
import 'package:admob_lib_flutter/AppLifecycleReactor.dart';
import 'package:admob_lib_flutter/AppOpenAdManager.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  // runApp(MyApp());
  runApp(
    MaterialApp(
      home: MyApp(),
      builder: EasyLoading.init(),
    ),
  );
}

const String testDevice = 'YOUR_DEVICE_ID';
const int maxFailedLoadAttempts = 3;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    AdmodUtils.configurationAdmob(isDebug: true, isShowAds: true);
    AdmodUtils.loadAppOpenAd();
    AdmodUtils.loadNativeAd(
        Androidid: "ca-app-pub-3940256099942544/2247696110",
        IOSid: "ca-app-pub-3940256099942544/2247696110",
        onAdLoaded: () {
          setState(() {
            Fluttertoast.showToast(msg: "onAdLoaded native");
            AdmodUtils.isNativeAdLoaded = true;
          });
        },
        onAdFailed: () {
          setState(() {
            Fluttertoast.showToast(msg: "onAdFailed native");

          });
        });

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('AdMob Example'),
          ),
          body: SafeArea(
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          child: Text("load and show InterstitialAd"),
                          onPressed: () {
                            AdmodUtils.loadAndShowAdInterstitialWithCallback(
                                Androidid:
                                    "ca-app-pub-3940256099942544/1033173712",
                                IOSid: "ca-app-pub-3940256099942544/4411468910",
                                enableLoadingDialog: true,
                                onAdClosed: () {
                                  Fluttertoast.showToast(msg: "onAdClose");
                                },
                                onAdFail: () {
                                  Fluttertoast.showToast(msg: "onAdFail");
                                });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          child: Text("load and show RewardedAd"),
                          onPressed: () {
                            AdmodUtils.loadAndShowAdRewardWithCallback(
                                Androidid:
                                    "ca-app-pub-3940256099942544/1033173712",
                                IOSid: "ca-app-pub-3940256099942544/4411468910",
                                enableLoadingDialog: true,
                                onAdClosed: () {
                                  Fluttertoast.showToast(msg: "onAdClose");
                                  // if(onUserEarned) ... else ...
                                },
                                onUserEarned: () {
                                  Fluttertoast.showToast(msg: "onUserEarned");
                                  // onUserEarned = true
                                },
                                onAdFail: () {
                                  Fluttertoast.showToast(msg: "onAdFail");
                                  // if(onUserEarned) ... else ...
                                });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      child: Text("loadBanner"),
                      onPressed: () {
                        AdmodUtils.loadAdBanner(
                            Androidid: 'ca-app-pub-3940256099942544/6300978111',
                            IOSid: 'ca-app-pub-3940256099942544/2934735716',
                            onAdLoaded: () {
                              setState(() {
                                Fluttertoast.showToast(
                                    msg: "onAdLoaded "
                                        "Banner");
                              });
                            },
                            onAdFailed: () {
                              setState(() {
                                Fluttertoast.showToast(
                                    msg: "onAdFailed Banner");
                                //gone view
                              });
                            },
                            context: context);
                      },
                    ),
                    AdmodUtils.isNativeAdLoaded ?  Container(
                      alignment: Alignment.center,
                      child: AdWidget(ad: AdmodUtils.adNative),
                      width: MediaQuery.of(context).size.width,
                      height: 500,
                    ) : Container()
                  ],
                ),
                AdmodUtils().getAdWidget(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
