import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import Cookies from 'js-cookie';
import type { User } from '@/types';
import { authApi } from './api';

interface AuthState {
  user: User | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  
  // Actions
  setUser: (user: User) => void;
  clearAuth: () => void;
  updateUser: (userData: Partial<User>) => void;
  
  // Auth operations
  login: (email: string, password: string) => Promise<void>;
  register: (data: { email: string; password: string; password2: string; first_name?: string; last_name?: string }) => Promise<void>;
  logout: () => Promise<void>;
  fetchUser: () => Promise<void>;
  
  // OAuth
  googleLogin: (code: string) => Promise<void>;
  githubLogin: (code: string) => Promise<void>;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set, get) => ({
      user: null,
      isAuthenticated: false,
      isLoading: false,

      setUser: (user) => set({ user, isAuthenticated: true }),
      
      clearAuth: () => {
        Cookies.remove('access_token');
        Cookies.remove('refresh_token');
        set({ user: null, isAuthenticated: false });
      },
      
      updateUser: (userData) =>
        set((state) => ({
          user: state.user ? { ...state.user, ...userData } : null,
        })),

      login: async (email, password) => {
        set({ isLoading: true });
        try {
          const response = await authApi.login({ email, password });
          set({ user: response.user, isAuthenticated: true, isLoading: false });
        } catch (error) {
          set({ isLoading: false });
          throw error;
        }
      },

      register: async (data) => {
        set({ isLoading: true });
        try {
          const response = await authApi.register(data);
          set({ user: response.user, isAuthenticated: true, isLoading: false });
        } catch (error) {
          set({ isLoading: false });
          throw error;
        }
      },

      logout: async () => {
        set({ isLoading: true });
        try {
          await authApi.logout();
        } finally {
          get().clearAuth();
          set({ isLoading: false });
        }
      },

      fetchUser: async () => {
        const token = Cookies.get('access_token');
        if (!token) {
          set({ user: null, isAuthenticated: false });
          return;
        }
        
        set({ isLoading: true });
        try {
          const user = await authApi.me();
          set({ user, isAuthenticated: true, isLoading: false });
        } catch (error) {
          get().clearAuth();
          set({ isLoading: false });
        }
      },

      googleLogin: async (code) => {
        set({ isLoading: true });
        try {
          const response = await authApi.googleAuth(code);
          set({ user: response.user, isAuthenticated: true, isLoading: false });
        } catch (error) {
          set({ isLoading: false });
          throw error;
        }
      },

      githubLogin: async (code) => {
        set({ isLoading: true });
        try {
          const response = await authApi.githubAuth(code);
          set({ user: response.user, isAuthenticated: true, isLoading: false });
        } catch (error) {
          set({ isLoading: false });
          throw error;
        }
      },
    }),
    {
      name: 'jobscouter-auth',
      partialize: (state) => ({
        user: state.user,
        isAuthenticated: state.isAuthenticated,
      }),
    }
  )
);

// Hook to check if user has pro subscription
export const useIsPro = () => {
  const user = useAuthStore((state) => state.user);
  return user?.subscription_tier === 'pro' || user?.subscription_tier === 'enterprise';
};

// Hook to check application limit
export const useApplicationLimit = () => {
  const user = useAuthStore((state) => state.user);
  const isPro = user?.subscription_tier === 'pro' || user?.subscription_tier === 'enterprise';
  const limit = isPro ? Infinity : 20; // Free tier: 20 applications
  // TODO: Get actual used count from analytics
  const used = 0;
  return { limit, used };
};

