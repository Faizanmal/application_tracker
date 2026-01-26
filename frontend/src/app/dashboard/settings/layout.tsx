'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import {
  User,
  CreditCard,
  Bell,
  Shield,
  Palette,
  LucideIcon,
} from 'lucide-react';
import { cn } from '@/lib/utils';

interface SettingsNavItem {
  title: string;
  href: string;
  icon: LucideIcon;
}

const settingsNav: SettingsNavItem[] = [
  {
    title: 'Profile',
    href: '/dashboard/settings',
    icon: User,
  },
  {
    title: 'Billing',
    href: '/dashboard/settings/billing',
    icon: CreditCard,
  },
  {
    title: 'Notifications',
    href: '/dashboard/settings/notifications',
    icon: Bell,
  },
  {
    title: 'Security',
    href: '/dashboard/settings/security',
    icon: Shield,
  },
  {
    title: 'Appearance',
    href: '/dashboard/settings/appearance',
    icon: Palette,
  },
];

export default function SettingsLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const pathname = usePathname();

  return (
    <div className="p-6">
      <div className="mb-8">
        <h1 className="text-2xl font-bold">Settings</h1>
        <p className="text-muted-foreground">
          Manage your account settings and preferences
        </p>
      </div>

      <div className="flex flex-col md:flex-row gap-8">
        {/* Settings Navigation */}
        <nav className="md:w-48 lg:w-56 flex-shrink-0">
          <ul className="space-y-1">
            {settingsNav.map((item) => {
              const isActive = 
                pathname === item.href || 
                (item.href !== '/dashboard/settings' && pathname.startsWith(item.href));
              
              return (
                <li key={item.href}>
                  <Link
                    href={item.href}
                    className={cn(
                      'flex items-center gap-3 px-3 py-2 rounded-lg text-sm transition-colors',
                      isActive
                        ? 'bg-primary text-primary-foreground'
                        : 'text-muted-foreground hover:text-foreground hover:bg-muted'
                    )}
                  >
                    <item.icon className="h-4 w-4" />
                    {item.title}
                  </Link>
                </li>
              );
            })}
          </ul>
        </nav>

        {/* Settings Content */}
        <div className="flex-1 min-w-0">
          {children}
        </div>
      </div>
    </div>
  );
}
