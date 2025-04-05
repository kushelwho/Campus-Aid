# Campus Aid

Campus Aid is a comprehensive student platform designed to streamline essential campus services through technology and automation. The app integrates three core modules to enhance the student experience:

- **AI-Powered Canteen & Mess Management**
- **Digital Lost & Found System**
- **Automated Scholarship Finder**

## Features

### 1. AI-Powered Canteen & Mess Management

The Campus Aid app features an AI-powered Canteen & Mess Management system that uses the Google Gemini API to provide personalized recommendations, nutrition analysis, and feedback for campus dining options.

#### Setup

1. **Get a Gemini API Key**
   - Go to https://ai.google.dev/ and sign up for a Gemini API key
   - Copy your API key

2. **Configure the Environment**
   - Open the `.env` file in the root directory
   - Replace `your_gemini_api_key_here` with your actual Gemini API key:
     ```
     GEMINI_API_KEY=your_actual_api_key_here
     ```

3. **Install Dependencies**
   - Run `flutter pub get` to install all required dependencies

#### Features

1. **AI-Powered Menu Recommendations**
   - Get personalized meal suggestions based on dietary preferences
   - Recommendations consider past meals and nutrition goals
   - Click "Generate Recommendations" in the menu screen to see AI-suggested meals

2. **Real-time Nutrition Analysis**
   - Select any meal and click "Nutrition" to see AI-generated nutrition information
   - Get detailed breakdown of estimated calories, macronutrients, and health benefits
   - All nutritional analysis is powered by Gemini AI for personalized insights

3. **Smart Feedback System**
   - Rate your meals and receive personalized responses
   - The AI analyzes your feedback to provide tailored responses
   - Helps campus staff understand and improve meal offerings

#### Usage

1. Navigate to the Canteen tab in the app
2. Toggle between vegetarian and non-vegetarian options as needed
3. Expand the AI Recommendations panel to see suggested meals
4. Click on any meal to view details and select "Nutrition" to see AI-generated analysis
5. Use the Feedback tab to rate meals and receive AI-generated responses

#### Technical Implementation

The AI features are implemented using:
- Google's Gemini API (via `google_generative_ai` package)
- Secure API key storage using `flutter_dotenv`
- Provider pattern for state management
- Asynchronous API calls for seamless user experience

### 2. Digital Lost & Found System
- Report lost items with details and verification questions
- Report found items with location and images
- Browse lost/found items with filters
- View items on interactive campus map
- Chat with finders/owners to arrange handovers

### 3. Automated Scholarship Finder
- Complete profile with academic and personal information
- Discover personalized scholarships with match percentages
- Filter and search for scholarships by category
- Track application progress
- Receive deadline reminders

## Getting Started

### Prerequisites
- Flutter SDK
- Android Studio / VS Code
- Android emulator or physical device

### Installation
1. Clone the repository:
```
git clone https://github.com/kushelwho/Campus-Aid.git
```

2. Navigate to the project directory:
```
cd campus_aid
```

3. Install dependencies:
```
flutter pub get
```

4. Run the app:
```
flutter run
```

## Project Structure
```
lib/
├── config/           # App configuration
├── core/             # Core utilities
├── features/         # Feature modules
│   ├── auth/         # Authentication feature
│   ├── canteen/      # Canteen management feature
│   ├── dashboard/    # Home dashboard
│   ├── lost_found/   # Lost and found feature
│   ├── scholarship/  # Scholarship feature
├── shared/           # Shared components
├── app.dart          # App entry point
├── main.dart         # Main entry point
```

## Modules

### Authentication
- Login with email/password or OAuth
- Registration with validation
- Profile management

### Dashboard
- Home screen with quick access to all modules
- Notification center
- Personalized recommendations

### Canteen Management
- Menu display with filtering
- Meal booking system
- Feedback mechanism

### Lost & Found
- Item reporting forms
- Browsing interface
- Interactive map view
- Messaging system for item claiming

### Scholarship Finder
- Profile setup for scholarship matching
- Scholarship discovery feed
- Application tracking
- Document management

## Future Enhancements
- Integration with campus payment systems
- AI-powered meal recommendations
- Real-time notifications for lost item matches
- Scholarship application analytics
- Dark mode and additional themes

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## License
This project is licensed under the MIT License - see the LICENSE file for details.
