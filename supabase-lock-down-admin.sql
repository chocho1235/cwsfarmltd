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
