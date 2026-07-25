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

-- ══════════ Migración 2026-07 — CRO: origen del lead + presupuesto actual ══════════
-- Manu: corré este bloque una sola vez en el SQL Editor de Supabase ANTES de
-- publicar el nuevo index.html. Si no lo corrés, la web sigue funcionando
-- igual (el insert falla en silencio, como ya pasaba antes con errores de
-- red), pero se pierden estos 2 datos nuevos hasta que agregues las columnas.
alter table public.leads add column if not exists origen text;          -- qué botón/sección abrió el formulario (hero, servicio_agencia, sticky_bar, etc.)
alter table public.leads add column if not exists monthly_budget text;  -- cuánto invierte HOY al mes en anuncios (nuevo campo de calificación)

alter table public.leads enable row level security;

-- El anon key solo puede INSERTAR (nunca leer ni borrar):
create policy "anon puede insertar leads"
  on public.leads for insert
  to anon
  with check (true);

-- Leer solo desde el dashboard de Supabase (rol autenticado/service).
