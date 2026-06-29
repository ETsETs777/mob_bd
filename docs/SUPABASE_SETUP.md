# Supabase setup for EcoPulse Cloud

EcoPulse Cloud syncs **user profile** and **watchlist** to Supabase when the app is built with compile-time keys.

## 1. Create a Supabase project

1. Go to [supabase.com](https://supabase.com) and create a project.
2. Copy **Project URL** and **anon public** key from **Settings → API**.

## 2. Database schema

Run in **SQL Editor**:

```sql
create table if not exists public.ecopulse_user_sync (
  user_id uuid primary key references auth.users (id) on delete cascade,
  payload jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.ecopulse_user_sync enable row level security;

create policy "Users read own sync row"
  on public.ecopulse_user_sync for select
  using (auth.uid() = user_id);

create policy "Users upsert own sync row"
  on public.ecopulse_user_sync for insert
  with check (auth.uid() = user_id);

create policy "Users update own sync row"
  on public.ecopulse_user_sync for update
  using (auth.uid() = user_id);
```

### Payload format

```json
{
  "profile": { "...": "UserProfile.toJson()" },
  "watchlist": ["crypto:bitcoin", "stockRu:SBER"],
  "updatedAt": "2026-06-28T12:00:00.000Z"
}
```

`watchlist` is an array of asset keys (`type:id`). Legacy payloads with full asset objects are also supported on download.

## 3. Auth providers

In Supabase **Authentication → Providers**:

- **Email**: enable (optional email confirmation as you prefer).
- **Google**: enable and add OAuth client IDs from Google Cloud Console.
  - For mobile, configure redirect/deep link per [Supabase Flutter docs](https://supabase.com/docs/guides/auth/social-login/auth-google?platform=flutter).

Apple Sign-In is planned separately (see `FULL_IMPROVEMENT.md` item 3.13).

## 4. Build the app with keys

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

Release APK/AAB:

```bash
flutter build apk --release \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

Without these defines, cloud UI shows a “not configured” message and Supabase is not initialized.

## 5. In-app usage

**Profile → Server account → EcoPulse Cloud**

- Sign in with email/password or Google.
- **Upload** pushes local profile + watchlist.
- **Download** merges remote data into the device.

Home server (LAN) and Supabase cloud are independent: you can use either or both.
