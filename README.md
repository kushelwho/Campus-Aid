# Campus Aid

Campus Aid is a comprehensive student platform designed to streamline essential campus services through technology and automation. The app integrates three core modules to enhance the student experience:

- **AI-Powered Canteen & Mess Management**
- **Digital Lost & Found System**
- **Automated Scholarship Finder**

## Features

### 1. AI-Powered Canteen & Mess Management
- View daily/weekly menu with real-time updates
- Toggle dietary preferences (Veg/Non-Veg)
- Pre-book meals with date and time selection
- View nutrition information for dishes
- Submit feedback using emoji/slider-based rating system

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
