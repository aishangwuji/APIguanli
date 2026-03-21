# Frequently Asked Questions (FAQ)

## General

### What is UniBalance?
UniBalance is a privacy-first mobile app that helps you monitor your AI API balances across multiple platforms (OpenAI, Anthropic, DeepSeek, etc.) in one place.

### Is my API key safe?
**Yes.** Your API keys are stored exclusively in your device's secure storage (iOS Keychain / Android Keystore). We never upload or transmit your keys to any server.

### Do I need an account?
No. UniBalance works fully offline without registration. Your data never leaves your device.

## Features

### Which AI platforms are supported?
- OpenAI (GPT-4, GPT-3.5, etc.)
- Anthropic (Claude)
- DeepSeek
- Google Gemini
- Zhipu AI (智谱AI)
- Moonshot (Kimi)
- OneAPI compatible endpoints

### How does the refresh work?
UniBalance fetches real-time balance data directly from each platform's official API. It uses exponential backoff for rate-limited requests (HTTP 429).

### Can I set custom alerts?
Yes. You can set threshold alerts (e.g., "notify me when balance < $5" or "when balance < 10%").

## Security

### What happens if I lose my phone?
Your API keys remain secure as long as your device is protected. We recommend enabling biometric authentication (Face ID / Touch ID).

### How can I delete my data?
Go to Settings > Delete All Data. This will remove all stored API keys and balance history from your device.

## Troubleshooting

### "Unable to fetch balance" error
1. Check your internet connection
2. Verify your API key is correct
3. Some platforms rate-limit requests - wait a few minutes and retry
4. Check if the platform's API is operational

### App crashes on launch
1. Update to the latest version
2. Restart your device
3. If issue persists, report via GitHub Issues

## Contact & Support

- **GitHub Issues**: https://github.com/aishangwuji/APIguanli/issues
- **Email**: [Contact email to be added]

---

Still have questions? Feel free to open an issue on GitHub.
