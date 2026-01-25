package com.elixir.esports

import android.os.Build
import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // 实现边缘到边缘支持，确保在Android 15及以上版本的兼容性
        WindowCompat.setDecorFitsSystemWindows(window, false)
    }
}
