# 一次性写入 UI 主题与布局（只动 app/src/main/res/**）
# 在你的 Android 项目“根目录”运行

set -euo pipefail

mkdir -p app/src/main/res/values app/src/main/res/values-night app/src/main/res/layout

# 1) values/colors.xml
cat > app/src/main/res/values/colors.xml << 'XML'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Brand Palette (Light) -->
    <color name="brand_primary">#2563EB</color>
    <color name="brand_on_primary">#FFFFFF</color>

    <color name="brand_secondary">#14B8A6</color>
    <color name="brand_on_secondary">#FFFFFF</color>

    <color name="brand_tertiary">#F59E0B</color>
    <color name="brand_on_tertiary">#1F2937</color>

    <color name="brand_background">#F8FAFC</color>
    <color name="brand_on_background">#0B1220</color>

    <color name="brand_surface">#FFFFFF</color>
    <color name="brand_on_surface">#111827</color>

    <color name="brand_outline">#D1D5DB</color>

    <color name="brand_error">#B00020</color>
    <color name="brand_on_error">#FFFFFF</color>

    <color name="brand_status_bar">#1E3A8A</color>
    <color name="brand_nav_bar">#FFFFFF</color>
</resources>
XML

# 2) values-night/colors.xml
cat > app/src/main/res/values-night/colors.xml << 'XML'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Brand Palette (Dark) -->
    <color name="brand_primary">#93C5FD</color>
    <color name="brand_on_primary">#0B1220</color>

    <color name="brand_secondary">#5EEAD4</color>
    <color name="brand_on_secondary">#0B1220</color>

    <color name="brand_tertiary">#FBBF24</color>
    <color name="brand_on_tertiary">#0B1220</color>

    <color name="brand_background">#0B1220</color>
    <color name="brand_on_background">#E5E7EB</color>

    <color name="brand_surface">#111827</color>
    <color name="brand_on_surface">#E5E7EB</color>

    <color name="brand_outline">#374151</color>

    <color name="brand_error">#CF6679</color>
    <color name="brand_on_error">#0B1220</color>

    <color name="brand_status_bar">#0B1220</color>
    <color name="brand_nav_bar">#0B1220</color>
</resources>
XML

# 3) values/themes.xml
cat > app/src/main/res/values/themes.xml << 'XML'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- 如果你的 Manifest 里用的是别的主题名，可把 Theme.Sy4 改成你现有的主题名即可 -->
    <style name="Theme.Sy4" parent="Theme.MaterialComponents.DayNight.NoActionBar">
        <!-- 主题主色 -->
        <item name="colorPrimary">@color/brand_primary</item>
        <item name="colorOnPrimary">@color/brand_on_primary</item>

        <item name="colorSecondary">@color/brand_secondary</item>
        <item name="colorOnSecondary">@color/brand_on_secondary</item>

        <item name="colorTertiary">@color/brand_tertiary</item>
        <item name="colorOnTertiary">@color/brand_on_tertiary</item>

        <item name="android:colorBackground">@color/brand_background</item>
        <item name="colorSurface">@color/brand_surface</item>
        <item name="colorOnSurface">@color/brand_on_surface</item>

        <item name="colorError">@color/brand_error</item>
        <item name="colorOnError">@color/brand_on_error</item>
        <item name="colorOutline">@color/brand_outline</item>

        <!-- 兼容旧控件 -->
        <item name="colorAccent">@color/brand_primary</item>
        <item name="android:colorAccent">@color/brand_primary</item>

        <!-- 系统栏颜色 -->
        <item name="android:statusBarColor">@color/brand_status_bar</item>
        <item name="android:navigationBarColor">@color/brand_nav_bar</item>

        <!-- 默认控件样式（只影响外观，不改 id/逻辑） -->
        <item name="toolbarStyle">@style/App.Toolbar</item>
        <item name="materialButtonStyle">@style/App.Button</item>
        <item name="textInputStyle">@style/App.TextInputLayout</item>
    </style>
</resources>
XML

# 4) values/styles.xml
cat > app/src/main/res/values/styles.xml << 'XML'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- 顶部栏 -->
    <style name="App.Toolbar" parent="Widget.MaterialComponents.Toolbar">
        <item name="android:layout_height">56dp</item>
        <item name="titleCentered">true</item>
        <item name="android:background">@color/brand_surface</item>
        <item name="android:titleTextColor">@color/brand_on_surface</item>
    </style>

    <!-- 默认按钮 -->
    <style name="App.Button" parent="Widget.MaterialComponents.Button">
        <item name="android:minHeight">48dp</item>
        <item name="android:paddingStart">20dp</item>
        <item name="android:paddingEnd">20dp</item>
        <item name="android:textAllCaps">false</item>
    </style>

    <!-- 文本输入外框 -->
    <style name="App.TextInputLayout" parent="Widget.MaterialComponents.TextInputLayout.OutlinedBox">
        <item name="boxBackgroundMode">outline</item>
        <item name="boxCornerRadiusTopStart">16dp</item>
        <item name="boxCornerRadiusTopEnd">16dp</item>
        <item name="boxCornerRadiusBottomStart">16dp</item>
        <item name="boxCornerRadiusBottomEnd">16dp</item>
        <item name="boxStrokeColor">@color/brand_outline</item>
        <item name="hintTextColor">@color/brand_on_surface</item>
    </style>
</resources>
XML

# 5) layout/include_top_appbar.xml（可选，用于在页面里统一顶栏）
cat > app/src/main/res/layout/include_top_appbar.xml << 'XML'
<?xml version="1.0" encoding="utf-8"?>
<com.google.android.material.appbar.MaterialToolbar
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:id="@+id/toolbar"
    style="@style/App.Toolbar"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    app:title="@string/app_name"/>
XML

echo "✅ 已写入完成：只动 UI（colors / themes / styles / include_top_appbar）。"
echo "👉 若 Manifest 主题名不是 Theme.Sy4，请把 values/themes.xml 里的样式名改成你现有主题名即可。"
