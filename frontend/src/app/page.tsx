import Link from 'next/link';
import {
  Briefcase,
  LayoutDashboard,
  Bell,
  LineChart,
  Sparkles,
  CheckCircle,
  ArrowRight,
  Star,
  Zap,
  Shield,
  Clock,
} from 'lucide-react';

import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';

const FEATURES = [
  {
    icon: LayoutDashboard,
    title: 'Kanban Board',
    description: 'Track applications visually with drag-and-drop status updates',
  },
  {
    icon: Bell,
    title: 'Smart Reminders',
    description: 'Never miss a follow-up with automated reminder notifications',
  },
  {
    icon: LineChart,
    title: 'Analytics Dashboard',
    description: 'Gain insights into your job search progress and patterns',
  },
  {
    icon: Sparkles,
    title: 'AI-Powered Tools',
    description: 'Generate follow-up emails, interview questions, and resume matching',
  },
  {
    icon: Clock,
    title: 'Interview Prep',
    description: 'Prepare with STAR method responses and company research',
  },
  {
    icon: Shield,
    title: 'Resume Management',
    description: 'Store and organize multiple resume versions for different roles',
  },
];

const TESTIMONIALS = [
  {
    quote: "JobScouter helped me land my dream job at Google! The interview prep features were invaluable.",
    author: "Sarah K.",
    role: "Software Engineer at Google",
    avatar: "SK",
  },
  {
    quote: "Finally, a job tracker that actually helps instead of being another chore. The AI follow-up emails are a game-changer.",
    author: "Michael R.",
    role: "Product Manager at Meta",
    avatar: "MR",
  },
  {
    quote: "I went from chaotic spreadsheets to organized success. 10/10 would recommend!",
    author: "Emily T.",
    role: "UX Designer at Apple",
    avatar: "ET",
  },
];

const PRICING = [
  {
    name: 'Free',
    price: 0,
    description: 'Get started with basic job tracking',
    features: [
      '25 active applications',
      '3 resume uploads',
      'Basic analytics',
      'Email reminders',
      'Kanban board',
    ],
    cta: 'Get Started',
    popular: false,
  },
  {
    name: 'Pro',
    price: 9.99,
    description: 'Everything you need to land your dream job',
    features: [
      'Unlimited applications',
      'Unlimited resumes',
      'Advanced analytics',
      'AI follow-up emails',
      'AI resume matching',
      'AI interview questions',
      'Priority support',
    ],
    cta: 'Start Free Trial',
    popular: true,
  },
];

export default function Home() {
  return (
    <div className="min-h-screen bg-gradient-to-b from-background to-muted/30">
      {/* Header */}
      <header className="border-b bg-background/80 backdrop-blur-sm sticky top-0 z-50">
        <div className="container mx-auto px-4 h-16 flex items-center justify-between">
          <Link href="/" className="flex items-center gap-2">
            <Briefcase className="h-6 w-6 text-primary" />
            <span className="font-bold text-xl">JobScouter</span>
          </Link>
          <nav className="hidden md:flex items-center gap-8">
            <Link href="#features" className="text-muted-foreground hover:text-foreground transition-colors">
              Features
            </Link>
            <Link href="#pricing" className="text-muted-foreground hover:text-foreground transition-colors">
              Pricing
            </Link>
            <Link href="#testimonials" className="text-muted-foreground hover:text-foreground transition-colors">
              Testimonials
            </Link>
          </nav>
          <div className="flex items-center gap-4">
            <Button variant="ghost" asChild>
              <Link href="/login">Log In</Link>
            </Button>
            <Button asChild>
              <Link href="/register">Get Started</Link>
            </Button>
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <section className="container mx-auto px-4 py-20 md:py-32">
        <div className="max-w-4xl mx-auto text-center">
          <Badge variant="secondary" className="mb-4">
            <Zap className="mr-1 h-3 w-3" />
            Now with AI-powered features
          </Badge>
          <h1 className="text-4xl md:text-6xl font-bold tracking-tight mb-6">
            Track Your Job Search.
            <br />
            <span className="text-primary">Land Your Dream Job.</span>
          </h1>
          <p className="text-xl text-muted-foreground mb-8 max-w-2xl mx-auto">
            Stop losing track of applications in spreadsheets. JobScouter helps you organize, 
            track, and optimize your job search with powerful tools and AI assistance.
          </p>
          <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
            <Button size="lg" asChild>
              <Link href="/register">
                Start Free
                <ArrowRight className="ml-2 h-4 w-4" />
              </Link>
            </Button>
            <Button size="lg" variant="outline" asChild>
              <Link href="#features">Learn More</Link>
            </Button>
          </div>
          <p className="text-sm text-muted-foreground mt-4">
            No credit card required • Free forever plan available
          </p>
        </div>

        {/* Hero Image / Demo */}
        <div className="mt-16 relative">
          <div className="bg-gradient-to-b from-primary/10 to-transparent rounded-2xl p-8 border shadow-2xl">
            <div className="aspect-video bg-muted rounded-lg flex items-center justify-center">
              <div className="text-center">
                <LayoutDashboard className="h-16 w-16 mx-auto mb-4 text-muted-foreground" />
                <p className="text-muted-foreground">Interactive Dashboard Preview</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Stats Section */}
      <section className="border-y bg-muted/50 py-12">
        <div className="container mx-auto px-4">
          <div className="grid grid-cols-2 md:grid-cols-4 gap-8">
            <div className="text-center">
              <p className="text-4xl font-bold text-primary">10K+</p>
              <p className="text-muted-foreground">Active Users</p>
            </div>
            <div className="text-center">
              <p className="text-4xl font-bold text-primary">50K+</p>
              <p className="text-muted-foreground">Applications Tracked</p>
            </div>
            <div className="text-center">
              <p className="text-4xl font-bold text-primary">85%</p>
              <p className="text-muted-foreground">Interview Success Rate</p>
            </div>
            <div className="text-center">
              <p className="text-4xl font-bold text-primary">4.9/5</p>
              <p className="text-muted-foreground">User Rating</p>
            </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section id="features" className="container mx-auto px-4 py-20">
        <div className="text-center mb-16">
          <h2 className="text-3xl md:text-4xl font-bold mb-4">
            Everything You Need to Succeed
          </h2>
          <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
            Powerful features designed to streamline your job search and increase your chances of landing interviews.
          </p>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
          {FEATURES.map((feature) => (
            <Card key={feature.title} className="border-2 hover:border-primary/50 transition-colors">
              <CardHeader>
                <div className="h-12 w-12 rounded-lg bg-primary/10 flex items-center justify-center mb-4">
                  <feature.icon className="h-6 w-6 text-primary" />
                </div>
                <CardTitle>{feature.title}</CardTitle>
                <CardDescription>{feature.description}</CardDescription>
              </CardHeader>
            </Card>
          ))}
        </div>
      </section>

      {/* How It Works */}
      <section className="bg-muted/50 py-20">
        <div className="container mx-auto px-4">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold mb-4">
              How It Works
            </h2>
            <p className="text-xl text-muted-foreground">
              Get started in minutes and take control of your job search
            </p>
          </div>

          <div className="grid md:grid-cols-3 gap-8 max-w-4xl mx-auto">
            <div className="text-center">
              <div className="h-16 w-16 rounded-full bg-primary text-primary-foreground text-2xl font-bold flex items-center justify-center mx-auto mb-4">
                1
              </div>
              <h3 className="font-semibold text-lg mb-2">Create Your Account</h3>
              <p className="text-muted-foreground">
                Sign up in seconds with email or your Google/GitHub account
              </p>
            </div>
            <div className="text-center">
              <div className="h-16 w-16 rounded-full bg-primary text-primary-foreground text-2xl font-bold flex items-center justify-center mx-auto mb-4">
                2
              </div>
              <h3 className="font-semibold text-lg mb-2">Add Applications</h3>
              <p className="text-muted-foreground">
                Log your job applications and track them on the Kanban board
              </p>
            </div>
            <div className="text-center">
              <div className="h-16 w-16 rounded-full bg-primary text-primary-foreground text-2xl font-bold flex items-center justify-center mx-auto mb-4">
                3
              </div>
              <h3 className="font-semibold text-lg mb-2">Land Your Dream Job</h3>
              <p className="text-muted-foreground">
                Use insights and AI tools to optimize your search and ace interviews
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Testimonials */}
      <section id="testimonials" className="container mx-auto px-4 py-20">
        <div className="text-center mb-16">
          <h2 className="text-3xl md:text-4xl font-bold mb-4">
            Loved by Job Seekers
          </h2>
          <p className="text-xl text-muted-foreground">
            See what our users have to say about their experience
          </p>
        </div>

        <div className="grid md:grid-cols-3 gap-8">
          {TESTIMONIALS.map((testimonial) => (
            <Card key={testimonial.author}>
              <CardContent className="pt-6">
                <div className="flex gap-1 mb-4">
                  {[1, 2, 3, 4, 5].map((star) => (
                    <Star key={star} className="h-5 w-5 fill-yellow-400 text-yellow-400" />
                  ))}
                </div>
                <p className="text-muted-foreground mb-6">&quot;{testimonial.quote}&quot;</p>
                <div className="flex items-center gap-3">
                  <div className="h-10 w-10 rounded-full bg-primary/10 flex items-center justify-center text-sm font-medium">
                    {testimonial.avatar}
                  </div>
                  <div>
                    <p className="font-medium">{testimonial.author}</p>
                    <p className="text-sm text-muted-foreground">{testimonial.role}</p>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      </section>

      {/* Pricing */}
      <section id="pricing" className="bg-muted/50 py-20">
        <div className="container mx-auto px-4">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold mb-4">
              Simple, Transparent Pricing
            </h2>
            <p className="text-xl text-muted-foreground">
              Start free and upgrade when you need more power
            </p>
          </div>

          <div className="grid md:grid-cols-2 gap-8 max-w-3xl mx-auto">
            {PRICING.map((plan) => (
              <Card 
                key={plan.name} 
                className={`relative ${plan.popular ? 'border-primary ring-2 ring-primary' : ''}`}
              >
                {plan.popular && (
                  <div className="absolute -top-3 left-1/2 -translate-x-1/2">
                    <Badge className="bg-primary">Most Popular</Badge>
                  </div>
                )}
                <CardHeader className="text-center pt-8">
                  <CardTitle className="text-2xl">{plan.name}</CardTitle>
                  <div className="mt-4">
                    <span className="text-4xl font-bold">${plan.price}</span>
                    <span className="text-muted-foreground">/month</span>
                  </div>
                  <CardDescription className="mt-2">{plan.description}</CardDescription>
                </CardHeader>
                <CardContent className="space-y-4">
                  <ul className="space-y-3">
                    {plan.features.map((feature) => (
                      <li key={feature} className="flex items-center gap-2">
                        <CheckCircle className="h-4 w-4 text-green-600" />
                        <span className="text-sm">{feature}</span>
                      </li>
                    ))}
                  </ul>
                  <Button 
                    className="w-full" 
                    variant={plan.popular ? 'default' : 'outline'}
                    asChild
                  >
                    <Link href="/register">{plan.cta}</Link>
                  </Button>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="container mx-auto px-4 py-20">
        <div className="max-w-3xl mx-auto text-center bg-primary text-primary-foreground rounded-2xl p-12">
          <h2 className="text-3xl md:text-4xl font-bold mb-4">
            Ready to Land Your Dream Job?
          </h2>
          <p className="text-xl opacity-90 mb-8">
            Join thousands of job seekers who&apos;ve transformed their job search with JobScouter.
          </p>
          <Button size="lg" variant="secondary" asChild>
            <Link href="/register">
              Get Started Free
              <ArrowRight className="ml-2 h-4 w-4" />
            </Link>
          </Button>
        </div>
      </section>

      {/* Footer */}
      <footer className="border-t py-12">
        <div className="container mx-auto px-4">
          <div className="grid grid-cols-2 md:grid-cols-4 gap-8">
            <div className="col-span-2 md:col-span-1">
              <Link href="/" className="flex items-center gap-2 mb-4">
                <Briefcase className="h-6 w-6 text-primary" />
                <span className="font-bold text-xl">JobScouter</span>
              </Link>
              <p className="text-sm text-muted-foreground">
                The smarter way to track your job search and land your dream role.
              </p>
            </div>
            <div>
              <h4 className="font-semibold mb-4">Product</h4>
              <ul className="space-y-2 text-sm text-muted-foreground">
                <li><Link href="#features" className="hover:text-foreground">Features</Link></li>
                <li><Link href="#pricing" className="hover:text-foreground">Pricing</Link></li>
                <li><Link href="/dashboard" className="hover:text-foreground">Dashboard</Link></li>
              </ul>
            </div>
            <div>
              <h4 className="font-semibold mb-4">Company</h4>
              <ul className="space-y-2 text-sm text-muted-foreground">
                <li><Link href="/about" className="hover:text-foreground">About</Link></li>
                <li><Link href="/blog" className="hover:text-foreground">Blog</Link></li>
                <li><Link href="/contact" className="hover:text-foreground">Contact</Link></li>
              </ul>
            </div>
            <div>
              <h4 className="font-semibold mb-4">Legal</h4>
              <ul className="space-y-2 text-sm text-muted-foreground">
                <li><Link href="/privacy" className="hover:text-foreground">Privacy</Link></li>
                <li><Link href="/terms" className="hover:text-foreground">Terms</Link></li>
              </ul>
            </div>
          </div>
          <div className="border-t mt-12 pt-8 text-center text-sm text-muted-foreground">
            <p>© {new Date().getFullYear()} JobScouter. All rights reserved.</p>
          </div>
        </div>
      </footer>
    </div>
  );
}
