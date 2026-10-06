-- Run this once in the Supabase SQL Editor (SQL Editor tab in your project dashboard).
-- Creates the horses table, seeds it with the horses currently on the site,
-- and sets up RLS policies so the site (public key) can read/write.

create table if not exists public.horses (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  age text,
  breed text,
  sex text,
  categories text,
  height text,
  price text,
  sold boolean not null default false,
  photo text,
  description text,
  sort_order integer not null default 0,
  created_at timestamptz not null default now()
);

alter table public.horses enable row level security;

-- Public (anon) read access — needed so the "Horses for Sale" page can load horses.
drop policy if exists "public can read horses" on public.horses;
create policy "public can read horses"
  on public.horses for select
  using (true);

-- Public (anon) write access — the admin page has no real server-side auth,
-- only a client-side password prompt. Anyone who calls the API directly could
-- write to this table. Acceptable for a low-stakes hobby site; not a security
-- boundary. Ask Claude for a server-checked version if that ever matters.
drop policy if exists "public can insert horses" on public.horses;
create policy "public can insert horses"
  on public.horses for insert
  with check (true);

drop policy if exists "public can update horses" on public.horses;
create policy "public can update horses"
  on public.horses for update
  using (true)
  with check (true);

drop policy if exists "public can delete horses" on public.horses;
create policy "public can delete horses"
  on public.horses for delete
  using (true);

-- Seed with the horses already on the site so nothing disappears when it goes live.
insert into public.horses (name, age, breed, sex, categories, height, price, sold, photo, description, sort_order) values
  ('Laddy', '2019', 'Irish Cob', 'Gelding', 'Allrounder // Riding Club // Hacking // Hunting', '14.2', 'POA', true, 'assets/laddy.jpg', null, 1),
  ('Mouse', '2021', 'Irish Sport Horse', 'Gelding', 'Allrounder // Eventer // Dressage // Riding Club', '16', 'POA', true, 'assets/mouse.jpg', 'Sold before hitting the open market. Please WhatsApp or call us for the latest horses, many of which sell before reaching our website.', 2),
  ('Horse Three', '2021', 'Irish Cob', 'Gelding', 'Allrounder // Hacking // Riding Club', '15', 'POA', true, null, null, 3),
  ('Horse Four', '2021', 'Irish Sport Horse', 'Gelding', 'Allrounder // Riding Club // Hacking // Hunting // Eventer', '16', 'POA', false, null, null, 4),
  ('Horse Five', '2017', 'Irish Sport Horse', 'Gelding', 'Allrounder // Riding Club // Hacking // Hunting', '15.2', 'POA', false, null, null, 5),
  ('Horse Six', '2015', 'Irish Draught', 'Gelding', 'Allrounder // Riding Club // Hunting // Eventer', '16.3', 'POA', false, null, null, 6);
