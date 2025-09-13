# Advanced Shopping List Frontend

Advanced Shopping List Cross-platform Frontend Application with AI-powered suggestions and voice input.

## Features

- 📸 **Camera Integration**: Take photos to get AI-powered product suggestions
- 🎤 **Voice Input**: Add items to your shopping list using voice commands
- 🤖 **AI Suggestions**: Get intelligent shopping recommendations based on your preferences
- 📋 **Smart Categories**: Automatic categorization of shopping items
- ✅ **Purchase Tracking**: Mark items as purchased with visual feedback
- 🔄 **Real-time Sync**: Synchronization with backend API
- 📱 **Cross-platform**: Works on iOS and Android

## Setup Instructions

### Prerequisites

- Flutter SDK (3.9.0 or higher)
- Dart SDK
- Android Studio / Xcode for mobile development
- OpenAI API key for voice transcription

### 1. Clone and Install Dependencies

```bash
git clone <repository-url>
cd advanced_shopping_list_frontend
flutter pub get
```

### 2. Configure OpenAI API Key (Secure Setup)

**⚠️ IMPORTANT: Voice input requires an OpenAI API key**

1. Get your OpenAI API key from [OpenAI Platform](https://platform.openai.com/api-keys)
2. Copy the example environment file:
   ```bash
   cp env.example .env
   ```
3. Edit the `.env` file and add your actual API key:
   ```
   OPENAI_API_KEY=sk-your-actual-openai-key-here
   ```

**🔒 Security Note**: 
- The `.env` file is automatically ignored by git and will never be committed
- Never share your API key or commit it to version control
- Each developer needs their own `.env` file with their own API key

### 3. Run the Application

```bash
# For Android development
flutter run

# For Android release
flutter run --release

# Target specific device (if multiple devices connected)
flutter run -d android
```

**📱 Platform Support**: Currently optimized for Android. iOS support available but Android is the primary target platform.

## Voice Input Usage

1. Tap the green microphone button at the bottom of the home screen
2. Grant microphone permissions when prompted
3. Tap the mic icon to start recording
4. Speak your shopping items (e.g., "Add milk, bread, and eggs to my list")
5. Tap again to stop recording
6. The app will transcribe your speech and send it to the AI for processing

## API Integration

The app integrates with the following endpoints:
- `/extractor/insert_data` - For processing voice transcriptions and text input
- `/shopping_list/get_shopping_list` - For retrieving AI suggestions
- `/category/categories` - For item categorization
- OpenAI Whisper API - For speech-to-text transcription

## Development Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [OpenAI API Documentation](https://platform.openai.com/docs/)
- [Flutter Bloc Pattern](https://bloclibrary.dev/)
