-- Run this once in the Supabase SQL Editor.
-- Lets the admin panel (which only ever holds the public "publishable" key,
-- never the secret key) upload/replace/delete photos directly in the
-- horse-photos bucket. Mirrors the existing open RLS on public.horses.
create policy "Public upload horse-photos" on storage.objects
  for insert with check (bucket_id = 'horse-photos');

create policy "Public update horse-photos" on storage.objects
  for update using (bucket_id = 'horse-photos');

create policy "Public delete horse-photos" on storage.objects
  for delete using (bucket_id = 'horse-photos');
