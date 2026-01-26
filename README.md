# JobScouter

JobScouter is a comprehensive job application tracking platform with web and mobile applications. It helps users manage their job applications, track interviews, set reminders, and analyze their job search progress.

## Project Structure

- **backend/**: Django REST API backend
- **frontend/**: Next.js web application
- **mobile/**: Flutter mobile application

## Setup

### Prerequisites

- Python 3.8+
- Node.js 18+
- Flutter SDK
- Docker (optional)

### Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Create a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Set up environment variables:
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

5. Run migrations:
   ```bash
   python manage.py migrate
   ```

6. Start the development server:
   ```bash
   python manage.py runserver
   ```

### Frontend Setup

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Set up environment variables:
   ```bash
   cp .env.example .env.local
   # Edit .env.local with your configuration
   ```

4. Start the development server:
   ```bash
   npm run dev
   ```

### Mobile Setup

1. Navigate to the mobile directory:
   ```bash
   cd mobile
   ```

2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Features

- Job application tracking
- Interview scheduling and management
- Reminder system
- Analytics and insights
- AI-powered features
- Subscription management
- Cross-platform support (Web, iOS, Android)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License.