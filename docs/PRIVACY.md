# Privacy Policy for UniBalance

**Last updated: 2026-03-20**

## Overview

UniBalance ("we", "our", or "app") is committed to protecting your privacy. This Privacy Policy explains how UniBalance handles your data when you use our application.

## Data We Collect

### API Keys (Never Leave Your Device)
- API keys are stored exclusively in your device's **Secure Enclave** (iOS Keychain / Android Keystore)
- We **never** transmit, upload, or sync your API keys to any server
- API keys are encrypted using AES-256-GCM before any local storage
- You can delete all stored API keys at any time from app settings

### Usage Data (Local Only)
- Balance history and usage statistics are stored **locally** on your device
- Data is stored using Isar database (on-device NoSQL)
- No data is sent to external servers

### App Analytics
- We use **minimal, privacy-preserving analytics** (optional, opt-in)
- No personal identifiable information is collected
- Analytics data is stored locally and never shared with third parties

## Third-Party Services

### AI Platform APIs
UniBalance connects directly to official AI platform APIs to fetch your balance data:
- OpenAI API
- Anthropic API
- DeepSeek API
- Google Gemini API
- Zhipu AI (智谱AI)
- Moonshot (Kimi)
- OneAPI compatible endpoints

These are **direct connections** between your device and the AI platforms' official APIs. Your API keys are sent only to these official endpoints.

## Permissions We Request

| Permission | Purpose |
|------------|---------|
| **Biometric Authentication** | Secure app access via Face ID / Touch ID |
| **Background Refresh** | Periodic balance checks (optional) |
| **Notifications** | Alert you when balances are low |
| **Network** | Connect to AI platform APIs |

## Data Security

- All API keys are encrypted using AES-256-GCM
- Sensitive data is stored in iOS Keychain / Android Keystore
- No data is transmitted through intermediary servers
- App binaries are obfuscated before release

## Your Rights

You have full control over your data:
- **Delete**: Remove all stored API keys and data from Settings
- **Export**: Manually export your data (future feature)
- **No Account Required**: App works fully offline without registration

## Children's Privacy

UniBalance is not intended for users under the age of 13. We do not knowingly collect data from children.

## Changes to This Policy

We will notify users of significant changes to this privacy policy through app updates.

## Contact Us

If you have questions about this Privacy Policy:
- GitHub Issues: https://github.com/aishangwuji/APIguanli/issues
- Email: [Your contact email]

---

**Interpretation**: This privacy policy is written in English. Translations are provided for convenience only. In case of discrepancies, the English version prevails.
