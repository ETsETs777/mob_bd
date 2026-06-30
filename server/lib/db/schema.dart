const schemaSql = '''
CREATE TABLE IF NOT EXISTS server_meta (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  login TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  display_name TEXT NOT NULL DEFAULT '',
  avatar_emoji TEXT NOT NULL DEFAULT '📈',
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS sessions (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  token_hash TEXT NOT NULL,
  expires_at TEXT NOT NULL,
  device_name TEXT,
  created_at TEXT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS threads (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL,
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS thread_members (
  thread_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  PRIMARY KEY (thread_id, user_id),
  FOREIGN KEY (thread_id) REFERENCES threads(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS messages (
  id TEXT PRIMARY KEY,
  thread_id TEXT NOT NULL,
  sender_id TEXT NOT NULL,
  text TEXT NOT NULL,
  created_at TEXT NOT NULL,
  edited_at TEXT,
  FOREIGN KEY (thread_id) REFERENCES threads(id),
  FOREIGN KEY (sender_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS audit_logs (
  id TEXT PRIMARY KEY,
  user_id TEXT,
  action TEXT NOT NULL,
  meta_json TEXT,
  created_at TEXT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_messages_thread ON messages(thread_id, created_at);
CREATE INDEX IF NOT EXISTS idx_thread_members_user ON thread_members(user_id);
CREATE INDEX IF NOT EXISTS idx_users_login ON users(login);

CREATE TABLE IF NOT EXISTS user_customizations (
  user_id TEXT PRIMARY KEY,
  payload_json TEXT NOT NULL,
  fingerprint TEXT NOT NULL DEFAULT '',
  updated_at TEXT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS user_articles (
  id TEXT PRIMARY KEY,
  author_id TEXT NOT NULL,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  reject_reason TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  moderated_at TEXT,
  moderated_by TEXT,
  FOREIGN KEY (author_id) REFERENCES users(id),
  FOREIGN KEY (moderated_by) REFERENCES users(id)
);

CREATE INDEX IF NOT EXISTS idx_user_articles_status ON user_articles(status, updated_at);
CREATE INDEX IF NOT EXISTS idx_user_articles_author ON user_articles(author_id, updated_at);

CREATE TABLE IF NOT EXISTS user_local_data (
  user_id TEXT PRIMARY KEY,
  payload_json TEXT NOT NULL,
  fingerprint TEXT NOT NULL DEFAULT '',
  updated_at TEXT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
);
''';

const defaultMeta = {
  'min_app_version': '1.0.44',
  'server_version': '1.0.0',
  'admin_logins': 'admin',
};
