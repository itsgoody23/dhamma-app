-- Enable Row Level Security on all user tables.
-- Policy: users can only access their own rows (auth.uid()::text = user_id).

-- ── user_bookmarks ──────────────────────────────────────────────────────────

ALTER TABLE user_bookmarks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own bookmarks"
  ON user_bookmarks FOR SELECT
  USING (auth.uid()::text = user_id);

CREATE POLICY "Users can insert own bookmarks"
  ON user_bookmarks FOR INSERT
  WITH CHECK (auth.uid()::text = user_id);

CREATE POLICY "Users can update own bookmarks"
  ON user_bookmarks FOR UPDATE
  USING (auth.uid()::text = user_id)
  WITH CHECK (auth.uid()::text = user_id);

CREATE POLICY "Users can delete own bookmarks"
  ON user_bookmarks FOR DELETE
  USING (auth.uid()::text = user_id);

-- ── user_highlights ─────────────────────────────────────────────────────────

ALTER TABLE user_highlights ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own highlights"
  ON user_highlights FOR SELECT
  USING (auth.uid()::text = user_id);

CREATE POLICY "Users can insert own highlights"
  ON user_highlights FOR INSERT
  WITH CHECK (auth.uid()::text = user_id);

CREATE POLICY "Users can update own highlights"
  ON user_highlights FOR UPDATE
  USING (auth.uid()::text = user_id)
  WITH CHECK (auth.uid()::text = user_id);

CREATE POLICY "Users can delete own highlights"
  ON user_highlights FOR DELETE
  USING (auth.uid()::text = user_id);

-- ── user_notes ──────────────────────────────────────────────────────────────

ALTER TABLE user_notes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own notes"
  ON user_notes FOR SELECT
  USING (auth.uid()::text = user_id);

CREATE POLICY "Users can insert own notes"
  ON user_notes FOR INSERT
  WITH CHECK (auth.uid()::text = user_id);

CREATE POLICY "Users can update own notes"
  ON user_notes FOR UPDATE
  USING (auth.uid()::text = user_id)
  WITH CHECK (auth.uid()::text = user_id);

CREATE POLICY "Users can delete own notes"
  ON user_notes FOR DELETE
  USING (auth.uid()::text = user_id);

-- ── user_progress ───────────────────────────────────────────────────────────

ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own progress"
  ON user_progress FOR SELECT
  USING (auth.uid()::text = user_id);

CREATE POLICY "Users can insert own progress"
  ON user_progress FOR INSERT
  WITH CHECK (auth.uid()::text = user_id);

CREATE POLICY "Users can update own progress"
  ON user_progress FOR UPDATE
  USING (auth.uid()::text = user_id)
  WITH CHECK (auth.uid()::text = user_id);

CREATE POLICY "Users can delete own progress"
  ON user_progress FOR DELETE
  USING (auth.uid()::text = user_id);
