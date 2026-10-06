-- Cornerwood: run this whole file once in the Supabase SQL Editor.
-- Part 1 locks writes to the signed-in admin and allows admin photo uploads.
-- Part 2 adds the Sweden/USA flag setting and fills in Ben and Freddie.

-- Run this once in the Supabase SQL Editor, AFTER the admin user exists
-- (Authentication > Users). It makes every write require a signed-in user.
-- Public visitors can still READ horses and photos; they can no longer
-- insert, edit, delete or upload anything, even with the public key.

-- horses table
drop policy if exists "public can insert horses" on public.horses;
drop policy if exists "public can update horses" on public.horses;
drop policy if exists "public can delete horses" on public.horses;
drop policy if exists "admin can insert horses" on public.horses;
drop policy if exists "admin can update horses" on public.horses;
drop policy if exists "admin can delete horses" on public.horses;

create policy "admin can insert horses" on public.horses
  for insert to authenticated with check (true);
create policy "admin can update horses" on public.horses
  for update to authenticated using (true) with check (true);
create policy "admin can delete horses" on public.horses
  for delete to authenticated using (true);

-- horse-photos storage bucket (reads stay public because the bucket is public)
drop policy if exists "Public upload horse-photos" on storage.objects;
drop policy if exists "Public update horse-photos" on storage.objects;
drop policy if exists "Public delete horse-photos" on storage.objects;
drop policy if exists "Admin upload horse-photos" on storage.objects;
drop policy if exists "Admin update horse-photos" on storage.objects;
drop policy if exists "Admin delete horse-photos" on storage.objects;

create policy "Admin upload horse-photos" on storage.objects
  for insert to authenticated with check (bucket_id = 'horse-photos');
create policy "Admin update horse-photos" on storage.objects
  for update to authenticated using (bucket_id = 'horse-photos');
create policy "Admin delete horse-photos" on storage.objects
  for delete to authenticated using (bucket_id = 'horse-photos');


-- Run this once in the Supabase SQL Editor.
-- Lets each sold horse be marked as exported to a country (USA or Sweden), so the
-- right flag shows under SOLD. Existing USA horses are carried over automatically.
alter table public.horses add column if not exists export_country text;

update public.horses set export_country = 'us'
  where exported_us = true and export_country is null;

-- Horses the old website showed with a Sweden flag: Ben (2011) and Freddie (2011).
update public.horses set export_country = 'se'
  where id in ('8f54beb5-9460-4cd5-a66d-4a0e03e35543', '390c8911-576e-4730-b284-9012263fcdb1');
