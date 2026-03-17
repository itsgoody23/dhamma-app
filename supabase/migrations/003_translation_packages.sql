-- Translation packages shared by community members.
-- Each package bundles one user's translations + commentary as JSON.

CREATE TABLE IF NOT EXISTS translation_packages (
  id              BIGSERIAL PRIMARY KEY,
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title           TEXT NOT NULL,
  description     TEXT NOT NULL DEFAULT '',
  author_name     TEXT NOT NULL DEFAULT 'Anonymous',
  language        TEXT NOT NULL DEFAULT 'en',
  translation_count INT NOT NULL DEFAULT 0,
  commentary_count  INT NOT NULL DEFAULT 0,
  package_json    JSONB NOT NULL,
  downloads       INT NOT NULL DEFAULT 0,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes for browsing
CREATE INDEX idx_translation_packages_language ON translation_packages(language);
CREATE INDEX idx_translation_packages_created_at ON translation_packages(created_at DESC);
CREATE INDEX idx_translation_packages_downloads ON translation_packages(downloads DESC);

-- RLS: anyone authenticated can read, only author can write
ALTER TABLE translation_packages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read packages"
  ON translation_packages FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authors can insert own packages"
  ON translation_packages FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Authors can update own packages"
  ON translation_packages FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Authors can delete own packages"
  ON translation_packages FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Auto-update updated_at
CREATE OR REPLACE FUNCTION update_translation_packages_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON translation_packages
  FOR EACH ROW
  EXECUTE FUNCTION update_translation_packages_updated_at();
