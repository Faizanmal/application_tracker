# JobScouter Frontend

This is the Next.js frontend application for JobScouter, a comprehensive job application tracking platform.

## Getting Started

### Prerequisites

- Node.js 18+
- npm, yarn, pnpm, or bun

### Installation

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```

2. Install dependencies:
   ```bash
   npm install
   # or
   yarn install
   # or
   pnpm install
   # or
   bun install
   ```

3. Set up environment variables:
   ```bash
   cp .env.example .env.local
   # Edit .env.local with your configuration
   ```

4. Run the development server:
   ```bash
   npm run dev
   # or
   yarn dev
   # or
   pnpm dev
   # or
   bun dev
   ```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

## Features

- Job application dashboard
- Interview scheduling
- Reminder management
- Analytics and insights
- User authentication
- Responsive design

## Tech Stack

- Next.js 14
- TypeScript
- Tailwind CSS
- React Query for data fetching
- NextAuth.js for authentication

## Project Structure

- `app/` - Next.js app router pages
- `components/` - Reusable React components
- `hooks/` - Custom React hooks
- `lib/` - Utility functions and configurations
- `types/` - TypeScript type definitions

## Building for Production

```bash
npm run build
npm start
```

## Testing

```bash
npm run test
```

## Deployment

This app can be deployed on Vercel, Netlify, or any platform supporting Next.js.

For Vercel deployment:
```bash
npm run build
```

Then connect your repository to Vercel for automatic deployments.

## Contributing

1. Follow the existing code style
2. Write tests for new features
3. Update documentation as needed
