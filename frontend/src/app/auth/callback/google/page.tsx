/* eslint-disable react-hooks/set-state-in-effect */
'use client';

import { useEffect, useState, useCallback } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { Loader2, CheckCircle, XCircle } from 'lucide-react';
import { toast } from 'sonner';
import { useAuthStore } from '@/lib/auth';

export default function GoogleCallbackPage() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const { googleLogin } = useAuthStore();
  const [status, setStatus] = useState<'loading' | 'success' | 'error'>('loading');
  const [error, setError] = useState<string>('');

  const handleGoogleCallback = useCallback(async (code: string) => {
    try {
      await googleLogin(code);
      setStatus('success');
      toast.success('Successfully signed in with Google!');
      setTimeout(() => {
        router.push('/dashboard');
      }, 1500);
    } catch (error: unknown) {
      setStatus('error');
      const err = error as { response?: { data?: { detail?: string } } };
      setError(err.response?.data?.detail || 'Failed to authenticate with Google.');
    }
  }, [router, googleLogin]);

  useEffect(() => {
    const code = searchParams.get('code');
    const errorParam = searchParams.get('error');

    if (errorParam) {
       
      setStatus('error');
       
      setError('Google authentication was cancelled or failed.');
      return;
    }

    if (code) {
      handleGoogleCallback(code);
    } else {
       
      setStatus('error');
       
      setError('No authorization code received from Google.');
    }
  }, [searchParams, handleGoogleCallback]);

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-100 dark:from-gray-900 dark:to-gray-800">
      <div className="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-8 max-w-md w-full text-center">
        {status === 'loading' && (
          <>
            <Loader2 className="h-16 w-16 animate-spin text-primary mx-auto mb-4" />
            <h2 className="text-xl font-semibold mb-2">Signing you in...</h2>
            <p className="text-muted-foreground">
              Please wait while we complete your Google sign-in.
            </p>
          </>
        )}

        {status === 'success' && (
          <>
            <CheckCircle className="h-16 w-16 text-green-500 mx-auto mb-4" />
            <h2 className="text-xl font-semibold mb-2">Success!</h2>
            <p className="text-muted-foreground">
              Redirecting you to your dashboard...
            </p>
          </>
        )}

        {status === 'error' && (
          <>
            <XCircle className="h-16 w-16 text-red-500 mx-auto mb-4" />
            <h2 className="text-xl font-semibold mb-2">Authentication Failed</h2>
            <p className="text-muted-foreground mb-4">{error}</p>
            <button
              onClick={() => router.push('/login')}
              className="text-primary hover:underline"
            >
              Return to login
            </button>
          </>
        )}
      </div>
    </div>
  );
}
