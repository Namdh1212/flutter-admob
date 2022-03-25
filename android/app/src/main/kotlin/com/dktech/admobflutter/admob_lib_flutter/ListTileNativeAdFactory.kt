/*
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.dktech.admobflutter.admob_lib_flutter

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.TextView;
import com.google.android.gms.ads.nativead.MediaView;
import com.google.android.gms.ads.nativead.NativeAd;
import com.google.android.gms.ads.nativead.NativeAdView;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin;
import java.util.Map;

class ListTileNativeAdFactory(val context: Context) : GoogleMobileAdsPlugin.NativeAdFactory {

    override fun createNativeAd(
            nativeAd: NativeAd,
            customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val adView = LayoutInflater.from(context)
                .inflate(R.layout.list_tile_native_ad, null) as NativeAdView

        // Set the media view.
        adView.setMediaView(adView.findViewById(R.id.ad_media) as MediaView)

        // Set other ad assets.
        adView.setHeadlineView(adView.findViewById(R.id.ad_headline))
        adView.setBodyView(adView.findViewById(R.id.ad_body))
        adView.setCallToActionView(adView.findViewById(R.id.ad_call_to_action))
        adView.setIconView(adView.findViewById(R.id.ad_app_icon))
//        adView.setPriceView(adView.findViewById(R.id.ad_price))
        adView.setStarRatingView(adView.findViewById(R.id.ad_stars))
//        adView.setStoreView(adView.findViewById(R.id.ad_store))
//        adView.setAdvertiserView(adView.findViewById(R.id.ad_advertiser))

        // The headline and mediaContent are guaranteed to be in every NativeAd.
        (adView.getHeadlineView() as TextView).setText(nativeAd.getHeadline())
        adView.getMediaView().setMediaContent(nativeAd.getMediaContent())

        // These assets aren't guaranteed to be in every NativeAd, so it's important to
        // check before trying to display them.
        if (nativeAd.getBody() == null) {
            adView.getBodyView().setVisibility(View.INVISIBLE)
        } else {
            adView.getBodyView().setVisibility(View.VISIBLE)
            (adView.getBodyView() as TextView).setText(nativeAd.getBody())
        }
        if (nativeAd.getCallToAction() == null) {
            adView.getCallToActionView().setVisibility(View.INVISIBLE)
        } else {
            adView.getCallToActionView().setVisibility(View.VISIBLE)
            (adView.getCallToActionView() as Button).setText(nativeAd.getCallToAction())
        }
        if (nativeAd.getIcon() == null) {
            adView.getIconView().setVisibility(View.GONE)
        } else {
            (adView.getIconView() as ImageView).setImageDrawable(nativeAd.getIcon().getDrawable())
            adView.getIconView().setVisibility(View.VISIBLE)
        }
        if (nativeAd.getStarRating() == null) {
            adView.getStarRatingView().setVisibility(View.INVISIBLE)
        } else {
            (adView.getStarRatingView() as RatingBar).rating = nativeAd.getStarRating().toFloat()
            adView.getStarRatingView().setVisibility(View.VISIBLE)
        }
        // This method tells the Google Mobile Ads SDK that you have finished populating your
        // native ad view with this native ad.
        adView.setNativeAd(nativeAd)
        return adView
    }
}
