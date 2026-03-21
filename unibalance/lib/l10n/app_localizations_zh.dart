// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'UniBalance';

  @override
  String get noProviders => '暂无监控的服务商';

  @override
  String get addFirstProvider => '点击右下角 + 添加你的第一个 API 服务商';

  @override
  String get addProvider => '添加服务商';

  @override
  String enterApiKey(String name) {
    return '输入你的 $name API Key';
  }

  @override
  String get apiKeyStored => '你的 API Key 仅存储在本地设备';

  @override
  String get cancel => '取消';

  @override
  String get add => '添加';

  @override
  String get used => '已用';

  @override
  String get available => '可用';

  @override
  String get total => '总额';

  @override
  String get tapToRefresh => '点击刷新余额';

  @override
  String get settings => '设置';

  @override
  String get security => '安全';

  @override
  String get biometricAuth => '生物识别认证';

  @override
  String get biometricDesc => '使用 Face ID 或 Touch ID 解锁';

  @override
  String get biometricUnavailable => '生物识别不可用';

  @override
  String get display => '显示';

  @override
  String get theme => '主题';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get themeLight => '浅色模式';

  @override
  String get themeDark => '深色模式';

  @override
  String get currency => '货币';

  @override
  String get alerts => '告警';

  @override
  String get alertThreshold => '余额告警阈值';

  @override
  String get about => '关于';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get version => '版本';

  @override
  String alreadyAdded(String name) {
    return '$name 已经添加过了';
  }
}
