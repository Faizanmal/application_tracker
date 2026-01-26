# JobScouter Backend

This is the Django REST API backend for the JobScouter application.

## Setup

### Prerequisites

- Python 3.8+
- PostgreSQL or SQLite (SQLite is used by default)

### Installation

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

6. Create a superuser (optional):
   ```bash
   python manage.py createsuperuser
   ```

7. Start the development server:
   ```bash
   python manage.py runserver
   ```

The API will be available at `http://localhost:8000`

## API Endpoints

- `/api/users/` - User management
- `/api/applications/` - Job applications
- `/api/interviews/` - Interview management
- `/api/reminders/` - Reminders
- `/api/analytics/` - Analytics
- `/api/ai-features/` - AI features
- `/api/subscriptions/` - Subscription management

## Testing

Run tests with:
```bash
python manage.py test
```

## Deployment

For production deployment, consider using:
- Gunicorn as WSGI server
- Nginx as reverse proxy
- PostgreSQL as database
- Redis for caching/session storage

## Contributing

1. Follow Django best practices
2. Write tests for new features
3. Update documentation as needed