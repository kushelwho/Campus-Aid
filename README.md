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

### 2. Digital Lost & Found System

The Lost & Found module provides a streamlined way for students to report, search for, and claim lost or found items on campus.

#### Features

1. **Item Reporting**
   - Report lost items with detailed descriptions and verification questions
   - Report found items with location information and photo uploads
   - Timestamp-based tracking system for all reported items

2. **Search and Discovery**
   - Browse through lost and found items with category filters
   - Search functionality to quickly find specific items
   - View items on an interactive campus map

3. **Claiming System**
   - Built-in chat functionality to connect item finders with owners
   - Verification questions to confirm rightful ownership
   - Arrangement of secure handover location

4. **Item Management**
   - Status tracking for items (lost, found, claimed, returned)
   - Notifications for potential matches
   - Item history and analytics

### 3. Automated Scholarship Finder

The Scholarship Finder helps students discover, filter, and apply for relevant scholarships based on their profile and eligibility.

#### Features

1. **Profile Management**
   - Create and update academic and personal profiles
   - Input eligibility criteria including grades, activities, and demographics
   - Upload and store required documents

2. **Scholarship Discovery**
   - Personalized scholarship recommendations with match percentages
   - Filter scholarships by category, amount, deadline, and eligibility
   - Save favorite scholarships for later reference

3. **Application Tracking**
   - Track application progress from discovery to submission
   - Deadline reminders and notifications
   - Document management for submission requirements

## Additional Features

### Authentication System
- Secure login with email/password
- User registration with validation
- Password reset functionality

### User Profile Management
- View and edit personal information
- Academic profile management
- Preference settings

### Dashboard
- Centralized access to all modules
- Recent activity summary
- Quick actions menu

### Settings
- Theme customization (light/dark mode)
- Font size adjustment
- Notification preferences

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
cd Campus-Aid
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
├── core/             # Core utilities and providers
├── features/         # Feature modules
│   ├── auth/         # Authentication feature
│   ├── canteen/      # AI-powered canteen management 
│   ├── dashboard/    # Home dashboard
│   ├── lost_found/   # Lost and found system
│   ├── scholarship/  # Scholarship finder
│   ├── profile/      # User profile management
│   ├── settings/     # App settings
├── shared/           # Shared components and widgets
├── app.dart          # App configuration and routes
├── main.dart         # Main entry point
```

## Tech Stack
- **Flutter**: UI framework
- **Provider**: State management
- **Google Gemini API**: AI capabilities for canteen features
- **Material 3**: Design system
- **Flutter Dotenv**: Environment configuration

## Future Enhancements
- Push notifications for real-time alerts
- Integration with campus payment systems
- Enhanced AI features across all modules
- Offline support for core functionality
- Analytics dashboard for usage patterns

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## License
This project is licensed under the MIT License - see the LICENSE file for details.
