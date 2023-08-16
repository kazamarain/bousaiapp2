//
//  MapModels.swift
//  bousaiapp
//
//  Created by ユウ・カザマ on 2023/08/02.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()

        override init() {
            super.init() // スーパクラスのイニシャライザを実行
            manager.delegate = self // 自身をデリゲートプロパティに設定
            manager.requestWhenInUseAuthorization() // 位置情報を利用許可をリクエスト
            manager.desiredAccuracy = kCLLocationAccuracyBest // 最高精度の位置情報を要求
            manager.distanceFilter = 3.0 // 更新距離(m)
            manager.startUpdatingLocation()
        }

}

