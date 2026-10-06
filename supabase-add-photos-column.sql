-- Run this once in the Supabase SQL Editor.
alter table public.horses add column if not exists photos jsonb not null default '[]'::jsonb;
alter table public.horses add column if not exists exported_us boolean not null default false;
alter table public.horses add column if not exists videos jsonb not null default '[]'::jsonb;
