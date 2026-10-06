-- Run this once in the Supabase SQL Editor.
-- Lets each sold horse be marked as exported to a country (USA or Sweden), so the
-- right flag shows under SOLD. Existing USA horses are carried over automatically.
alter table public.horses add column if not exists export_country text;

update public.horses set export_country = 'us'
  where exported_us = true and export_country is null;

-- Horses the old website showed with a Sweden flag: Ben (2011) and Freddie (2011).
update public.horses set export_country = 'se'
  where id in ('8f54beb5-9460-4cd5-a66d-4a0e03e35543', '390c8911-576e-4730-b284-9012263fcdb1');
