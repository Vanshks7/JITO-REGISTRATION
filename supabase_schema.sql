-- ==============================================================================
-- JITO Ahmedabad Multi-Sports Registration - Supabase SQL Schema
-- Run this in your Supabase SQL Editor (Dashboard -> SQL Editor -> New Query -> Run)
-- ==============================================================================

-- 1. Create table for Players
CREATE TABLE IF NOT EXISTS public.jito_players (
    id TEXT PRIMARY KEY,                       -- e.g. MP1, FP1
    name TEXT NOT NULL,
    mobile TEXT NOT NULL,
    gender TEXT NOT NULL,
    age TEXT,
    membership TEXT,
    password TEXT NOT NULL,
    photo TEXT,                                -- Base64 data URL or Storage image URL
    registered_at TEXT,
    freq_pickleball TEXT,
    freq_cricket TEXT,
    freq_paddle TEXT,
    booking JSONB DEFAULT '{"hasBooked": false}'::jsonb,
    history JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index mobile for fast unique lookups
CREATE INDEX IF NOT EXISTS idx_jito_players_mobile ON public.jito_players(mobile);

-- 2. Create table for Global App State (Inventory, Sequence counters, Admin PIN)
CREATE TABLE IF NOT EXISTS public.jito_app_state (
    key TEXT PRIMARY KEY,
    value JSONB NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Enable Row Level Security (RLS) and allow Public access with Anon Key
ALTER TABLE public.jito_players ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.jito_app_state ENABLE ROW LEVEL SECURITY;

-- Allow anonymous read and write operations
CREATE POLICY "Allow public read access to players" 
ON public.jito_players FOR SELECT USING (true);

CREATE POLICY "Allow public insert/update to players" 
ON public.jito_players FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Allow public read access to app_state" 
ON public.jito_app_state FOR SELECT USING (true);

CREATE POLICY "Allow public update/insert to app_state" 
ON public.jito_app_state FOR ALL USING (true) WITH CHECK (true);

-- Enable real-time replication if you want instant updates across devices (optional)
ALTER PUBLICATION supabase_realtime ADD TABLE public.jito_players;
ALTER PUBLICATION supabase_realtime ADD TABLE public.jito_app_state;
