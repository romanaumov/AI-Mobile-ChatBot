# AI Mobile ChatBot

A mobile chatbot application for iOS that allows you to interact with AI models from OpenAI and Anthropic.

## Features

- Choose between OpenAI and Anthropic as AI providers
- Select from various AI models including GPT-4o and Claude 3.7 Sonnet
- Enter your API key for authentication
- Chat interface for interacting with AI models

## Requirements

- iOS 15.0 or later
- iPhone 7 Plus or compatible device
- Valid API keys for OpenAI or Anthropic

## Building and Distributing an iOS App from Ubuntu

Since iOS app development traditionally requires macOS and Xcode, there are several workarounds for Ubuntu users. Here are your options:

### Option 1: Use a Cloud-Based Mac Service

Several services provide cloud-based Mac environments that you can use for iOS development:

1. **MacinCloud**: Rent a Mac in the cloud with Xcode installed
2. **MacStadium**: Provides dedicated Mac hardware in the cloud
3. **GitHub Actions**: Use GitHub's CI/CD with macOS runners for building

#### Steps for Cloud Mac Services:

1. Sign up for a cloud Mac service
2. Connect to the remote Mac via VNC or SSH
3. Clone your Flutter project on the remote Mac
4. Follow standard iOS build and submission steps on the remote Mac

### Option 2: Use Codemagic CI/CD Service

[Codemagic](https://codemagic.io/) is a CI/CD platform specifically designed for Flutter apps that can build and publish iOS apps without requiring a Mac.

1. Sign up for Codemagic
2. Connect your GitHub/GitLab/Bitbucket repository
3. Configure the build settings for iOS
4. Upload your Apple Developer certificates and profiles
5. Set up the workflow to build and publish to App Store Connect

### Option 3: Use a Mac Virtual Machine (Complex)

This is technically possible but challenging and may violate Apple's terms of service:

1. Set up a macOS virtual machine on Ubuntu
2. Install Xcode and Flutter on the VM
3. Build and submit your app from the VM

### Option 4: Use a Third-Party Distribution Service

For enterprise or ad-hoc distribution without the App Store:

1. **Diawi**: Upload your IPA file and share a link
2. **TestFlight**: Use a cloud Mac service to upload your build, then distribute via TestFlight
3. **Firebase App Distribution**: Distribute test builds to specific users

### Detailed Instructions for Codemagic (Recommended Option)

1. **Sign up for Codemagic**:
   - Go to [codemagic.io](https://codemagic.io/)
   - Sign up using GitHub, GitLab, Bitbucket, or email

2. **Set up your project**:
   - Add your Flutter project from your repository
   - Select the Flutter workflow

3. **Configure iOS build settings**:
   - Enable iOS build
   - Set the Xcode version
   - Configure the build mode (Debug/Release)
   - Set the Flutter version

4. **Add Apple Developer credentials**:
   - Upload your Apple Developer certificate
   - Add your provisioning profile
   - Configure App Store Connect API access

5. **Set up publishing**:
   - Enable "Publish to App Store Connect"
   - Configure the app's Bundle ID
   - Set up version tracking

6. **Start the build**:
   - Trigger a build manually or on git push
   - Monitor the build process
   - Check logs for any issues

7. **Submit to App Store**:
   - Once the build is uploaded to App Store Connect
   - Log in to App Store Connect in a browser
   - Complete app information and submit for review

### Installing the App on Your iPhone 7 Plus

Once your app is approved and available on the App Store:

1. Open the App Store on your iPhone 7 Plus
2. Search for your app by name
3. Tap "Get" or the price button
4. Authenticate with Face ID, Touch ID, or your Apple ID password
5. Wait for the app to download and install
6. Open the app from your home screen

### Using the App

1. Launch the AI Mobile ChatBot app on your iPhone
2. You'll be prompted to configure your settings first
3. Select your preferred AI provider (OpenAI or Anthropic) from the dropdown
4. Choose an AI model from the dropdown menu
5. Enter your API key for the selected provider
6. Tap "Save Settings" to connect to the AI service
7. Use the chat interface to send messages and receive responses from the AI

## Important Notes

1. **Apple Developer Program**: You still need to enroll in the Apple Developer Program ($99/year) to distribute through the App Store

2. **App Store Guidelines**: Your app must comply with [Apple's App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)

3. **Alternative Distribution**: If you don't want to use the App Store, consider:
   - Enterprise distribution (requires an Enterprise Developer account)
   - Ad-hoc distribution (limited to 100 devices)
   - Web app alternative (using Flutter web)
