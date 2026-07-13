-- Setup de captura de leads para manubaldiviezo.lat
-- 1. Crear proyecto en supabase.com (plan gratis alcanza)
-- 2. SQL Editor → pegar y ejecutar este archivo completo
-- 3. Copiar Project URL y anon key (Settings → API) en index.html:
--    const SUPABASE_URL = 'https://TUPROYECTO.supabase.co';
--    const SUPABASE_ANON_KEY = 'eyJ...';

create table if not exists public.leads (
  id          bigint generated always as identity primary key,
  created_at  timestamptz not null default now(),
  name        text not null,
  phone       text,
  business    text,
  city        text,
  invested_ads text,
  intent      text,          -- ConsultaGestion / ConsultaAsesoria / etc.
  source      text           -- whatsapp_qualify / recursos / etc.
);

alter table public.leads enable row level security;

-- El anon key solo puede INSERTAR (nunca leer ni borrar):
create policy "anon puede insertar leads"
  on public.leads for insert
  to anon
  with check (true);

-- Leer solo desde el dashboard de Supabase (rol autenticado/service).
