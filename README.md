# Flutter Reminder App

A Flutter application for managing reminders with user authentication and local storage.

## Features

- User authentication (login/logout)
- Create, read, update, and delete reminders
- Grid view of reminders
- Detailed view of each reminder
- Local storage using SQLite
- User-specific reminders

## Prerequisites

- Flutter SDK (latest version)
- Android Studio / Xcode (for mobile development)
- VS Code (recommended for development)
- Git

## Setup Instructions

1. Clone the repository:

```bash
git clone <repository-url>
cd reminder_app
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

## Login Credentials

The app comes with two pre-configured users:

1. Admin User:

   - Username: `admin`
   - Password: `12345`

2. Regular User:
   - Username: `user`
   - Password: `12345`

## Project Structure

```
lib/
├── database/
│   └── database_helper.dart    # SQLite database operations
├── models/
│   ├── reminder.dart          # Reminder data model
│   └── user.dart             # User data model
├── screens/
│   ├── login_screen.dart     # Login screen
│   ├── reminder_list_screen.dart    # List of reminders
│   ├── create_reminder_screen.dart  # Create new reminder
│   └── reminder_detail_screen.dart  # View/Edit reminder
└── main.dart                 # App entry point
```

## Features in Detail

### Login Screen

- Form validation
- Error handling for invalid credentials
- Secure password field

### Reminder List Screen

- Grid view of reminders
- Welcome message with username
- Logout button
- Create new reminder button
- Tap on reminder to view details

### Create Reminder Screen

- Title and description input
- Date and time picker
- Save and cancel buttons
- Confirmation dialog for cancellation

### Reminder Detail Screen

- View reminder details
- Update functionality
- Discard changes option
- Save changes option
- Confirmation dialog for discarding changes

## Database Schema

The app uses SQLite with the following schema:

```sql
CREATE TABLE reminders (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  description TEXT,
  dateTime TEXT NOT NULL,
  userId TEXT NOT NULL
)
```

## Development

To modify the app:

1. Update the database schema in `database_helper.dart`
2. Modify the models in the `models` directory
3. Update the UI in the `screens` directory
4. Test the changes using the provided test accounts

## Troubleshooting

If you encounter any issues:

1. Make sure all dependencies are installed:

```bash
flutter pub get
```

2. Clean the project:

```bash
flutter clean
```

3. Rebuild the project:

```bash
flutter pub get
flutter run
```
