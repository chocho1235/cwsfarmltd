-- Run this once in the Supabase SQL Editor.
--
-- WHY: Supabase lets anyone register an account, and the earlier rules trusted ANY
-- signed-in account. A stranger could have signed up and then edited or deleted
-- every horse and uploaded files. This restricts all changes to the admin email only.
--
-- To add a second admin later, add their email inside the array(...) in each policy.

-- horses table
drop policy if exists "admin can insert horses" on public.horses;
drop policy if exists "admin can update horses" on public.horses;
drop policy if exists "admin can delete horses" on public.horses;

create policy "admin can insert horses" on public.horses
  for insert to authenticated
  with check ((auth.jwt() ->> 'email') = any (array['henrybarcroft@gmail.com']));
create policy "admin can update horses" on public.horses
  for update to authenticated
  using ((auth.jwt() ->> 'email') = any (array['henrybarcroft@gmail.com']))
  with check ((auth.jwt() ->> 'email') = any (array['henrybarcroft@gmail.com']));
create policy "admin can delete horses" on public.horses
  for delete to authenticated
  using ((auth.jwt() ->> 'email') = any (array['henrybarcroft@gmail.com']));

-- horse-photos storage bucket (viewing photos stays public)
drop policy if exists "Admin upload horse-photos" on storage.objects;
drop policy if exists "Admin update horse-photos" on storage.objects;
drop policy if exists "Admin delete horse-photos" on storage.objects;
drop policy if exists "Admin read horse-photos" on storage.objects;

create policy "Admin upload horse-photos" on storage.objects
  for insert to authenticated
  with check (bucket_id = 'horse-photos' and (auth.jwt() ->> 'email') = any (array['henrybarcroft@gmail.com']));
create policy "Admin update horse-photos" on storage.objects
  for update to authenticated
  using (bucket_id = 'horse-photos' and (auth.jwt() ->> 'email') = any (array['henrybarcroft@gmail.com']));
create policy "Admin delete horse-photos" on storage.objects
  for delete to authenticated
  using (bucket_id = 'horse-photos' and (auth.jwt() ->> 'email') = any (array['henrybarcroft@gmail.com']));
create policy "Admin read horse-photos" on storage.objects
  for select to authenticated
  using (bucket_id = 'horse-photos' and (auth.jwt() ->> 'email') = any (array['henrybarcroft@gmail.com']));
