function parseTagsInput(raw) {
  if (!raw || !raw.trim()) return [];
  return raw.split(',').map((t) => t.trim()).filter(Boolean);
}

const STORAGE_KEY = 'ecopulse_admin_session';

function categoryLabel(cat) {
  const labels = {
    markets: 'Рынки',
    portfolio: 'Портфель',
    macro: 'Макро',
    learn: 'Обучение',
    community: 'Сообщество',
    other: 'Другое',
  };
  return labels[cat] || cat || 'Другое';
}

function versionSourceLabel(source) {
  const labels = {
    admin_update: 'Правка админа',
    author_update: 'Правка автора',
    unpublish: 'Снятие с публикации',
    pre_rollback: 'Перед откатом',
  };
  return labels[source] || source;
}

function roleLabel(role) {
  const labels = {
    moderator: 'Модератор',
    editor: 'Редактор',
    admin: 'Админ',
  };
  return labels[role] || 'Пользователь';
}

function canModerateRole(role) {
  return role === 'moderator' || role === 'admin';
}

function canEditRole(role) {
  return role === 'editor' || role === 'admin';
}

function isFullAdminRole(role) {
  return role === 'admin';
}

const state = {
  baseUrl: '',
  token: '',
  profile: null,
  currentView: 'dashboard',
};

function defaultBaseUrl() {
  if (location.origin && !location.origin.startsWith('file')) {
    return location.origin;
  }
  return 'http://127.0.0.1:8081';
}

function loadSession() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) return false;
    const data = JSON.parse(raw);
    state.baseUrl = data.baseUrl || defaultBaseUrl();
    state.token = data.token || '';
    state.profile = data.profile || null;
    return Boolean(state.token && state.profile?.isStaff);
  } catch {
    return false;
  }
}

function saveSession() {
  localStorage.setItem(
    STORAGE_KEY,
    JSON.stringify({
      baseUrl: state.baseUrl,
      token: state.token,
      profile: state.profile,
    }),
  );
}

function clearSession() {
  localStorage.removeItem(STORAGE_KEY);
  state.token = '';
  state.profile = null;
}

async function api(path, options = {}) {
  const url = `${state.baseUrl.replace(/\/$/, '')}${path}`;
  const headers = {
    'Content-Type': 'application/json',
    ...(options.headers || {}),
  };
  if (state.token) headers.Authorization = `Bearer ${state.token}`;

  const res = await fetch(url, { ...options, headers });
  let body = null;
  try {
    body = await res.json();
  } catch {
    body = null;
  }

  if (!res.ok) {
    const err = new Error(body?.error || res.statusText);
    err.code = body?.error;
    err.status = res.status;
    err.retryAfterSeconds = body?.retryAfterSeconds;
    throw err;
  }
  return body;
}

function fmtDate(iso) {
  if (!iso) return '—';
  try {
    return new Date(iso).toLocaleString('ru-RU');
  } catch {
    return iso;
  }
}

function statusBadge(status) {
  const labels = { approved: 'Опубликована', pending: 'Модерация', rejected: 'Отклонена' };
  return `<span class="status ${status}">${labels[status] || status}</span>`;
}

const coverState = {
  compose: { file: null, objectUrl: null, existingUrl: null, clear: false },
  dialog: { file: null, objectUrl: null, existingUrl: null, clear: false },
};

function mediaUrl(path) {
  if (!path) return null;
  if (path.startsWith('http')) return path;
  return `${state.baseUrl.replace(/\/$/, '')}${path}`;
}

function isScheduled(article) {
  if (!article?.publishAt) return false;
  return new Date(article.publishAt) > new Date();
}

function scheduleBadge(article) {
  if (!isScheduled(article)) return '';
  return `<span class="status scheduled">⏱ ${fmtDate(article.publishAt)}</span>`;
}

function toIsoPublishAt(localValue) {
  if (!localValue) return null;
  const d = new Date(localValue);
  if (Number.isNaN(d.getTime())) return null;
  return d.toISOString();
}

function toDatetimeLocal(iso) {
  if (!iso) return '';
  const d = new Date(iso);
  if (Number.isNaN(d.getTime())) return '';
  const pad = (n) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}T${pad(d.getHours())}:${pad(d.getMinutes())}`;
}

function renderMarkdown(src, coverUrl) {
  if (!src) return '<p class="hint">Пусто</p>';
  let text = String(src);
  const blocks = [];
  text = text.replace(/```([\s\S]*?)```/g, (_, code) => {
    const id = blocks.length;
    blocks.push(`<pre><code>${esc(code.trim())}</code></pre>`);
    return `\u0000BLOCK${id}\u0000`;
  });

  text = text.replace(/(?:^\|.+\|\r?\n)+/gm, (tableBlock) => {
    const lines = tableBlock.trim().split(/\r?\n/).filter((l) => l.trim());
    if (lines.length < 2) return tableBlock;
    const isSep = (line) => /^\|[\s\-:|]+\|$/.test(line.trim());
    const parseRow = (line) =>
      line
        .trim()
        .replace(/^\|/, '')
        .replace(/\|$/, '')
        .split('|')
        .map((c) => c.trim());
    const header = parseRow(lines[0]);
    const bodyLines = lines.slice(1).filter((l) => !isSep(l));
    const id = blocks.length;
    const headHtml = header.map((c) => `<th>${esc(c)}</th>`).join('');
    const bodyHtml = bodyLines
      .map((line) => {
        const cells = parseRow(line);
        return `<tr>${cells.map((c) => `<td>${esc(c)}</td>`).join('')}</tr>`;
      })
      .join('');
    blocks.push(`<table class="md-table"><thead><tr>${headHtml}</tr></thead><tbody>${bodyHtml}</tbody></table>`);
    return `\u0000BLOCK${id}\u0000`;
  });

  let html = esc(text);
  html = html.replace(/^### (.+)$/gm, '<h3>$1</h3>');
  html = html.replace(/^## (.+)$/gm, '<h2>$1</h2>');
  html = html.replace(/^# (.+)$/gm, '<h1>$1</h1>');
  html = html.replace(/!\[([^\]]*)\]\(([^)]+)\)/g, '<img alt="$1" src="$2" />');
  html = html.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2" target="_blank" rel="noopener">$1</a>');
  html = html.replace(/~~(.+?)~~/g, '<del>$1</del>');
  html = html.replace(/`([^`\n]+)`/g, '<code>$1</code>');
  html = html.replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>');
  html = html.replace(/\*(.+?)\*/g, '<em>$1</em>');
  html = html.replace(/^&gt; (.+)$/gm, '<blockquote>$1</blockquote>');
  html = html.replace(/^(\d+)\. (.+)$/gm, '<li class="ol">$2</li>');
  html = html.replace(/^- (.+)$/gm, '<li class="ul">$1</li>');
  html = html.replace(/(<li class="ol">[\s\S]*?<\/li>)/g, (m) => `<ol>${m.replace(/ class="ol"/g, '')}</ol>`);
  html = html.replace(/(<li class="ul">[\s\S]*?<\/li>)/g, (m) => `<ul>${m.replace(/ class="ul"/g, '')}</ul>`);
  html = html.replace(/^---$/gm, '<hr />');
  html = html.replace(/\u0000BLOCK(\d+)\u0000/g, (_, i) => blocks[Number(i)] || '');
  html = html.replace(/\n{2,}/g, '</p><p>');
  html = `<p>${html}</p>`;

  const cover = coverUrl
    ? `<img class="cover-hero" src="${esc(coverUrl)}" alt="Обложка" />`
    : '';
  return cover + html;
}

function mdWrapSelection(textarea, prefix, suffix, placeholder = '') {
  const start = textarea.selectionStart ?? textarea.value.length;
  const end = textarea.selectionEnd ?? textarea.value.length;
  const selected = start === end ? placeholder : textarea.value.slice(start, end);
  const replacement = `${prefix}${selected}${suffix}`;
  textarea.setRangeText(replacement, start, end, 'end');
  const cursor = start + prefix.length + selected.length + (start === end ? 0 : suffix.length);
  textarea.setSelectionRange(cursor, cursor);
  textarea.focus();
  textarea.dispatchEvent(new Event('input', { bubbles: true }));
}

function mdInsertLinePrefix(textarea, prefix) {
  let start = textarea.selectionStart ?? textarea.value.length;
  while (start > 0 && textarea.value[start - 1] !== '\n') start -= 1;
  textarea.setRangeText(prefix, start, start, 'end');
  textarea.setSelectionRange(start + prefix.length, start + prefix.length);
  textarea.focus();
  textarea.dispatchEvent(new Event('input', { bubbles: true }));
}

function mdInsertBlock(textarea, block) {
  const offset = textarea.selectionStart ?? textarea.value.length;
  const needsGap = textarea.value.length > 0 && !textarea.value.endsWith('\n\n');
  const insertion = `${needsGap ? '\n\n' : ''}${block}\n\n`;
  textarea.setRangeText(insertion, offset, offset, 'end');
  textarea.setSelectionRange(offset + insertion.length, offset + insertion.length);
  textarea.focus();
  textarea.dispatchEvent(new Event('input', { bubbles: true }));
}

function mdInsertTable(textarea) {
  mdInsertBlock(
    textarea,
    '| Col 1 | Col 2 |\n| --- | --- |\n| … | … |',
  );
}

async function mdPromptUrl(title) {
  const url = prompt(title, 'https://');
  return url?.trim() || null;
}

function setupMarkdownToolbars() {
  const actions = [
    { label: 'B', title: 'Жирный', run: (ta) => mdWrapSelection(ta, '**', '**') },
    { label: 'I', title: 'Курсив', run: (ta) => mdWrapSelection(ta, '*', '*') },
    { label: 'S', title: 'Зачёркнутый', run: (ta) => mdWrapSelection(ta, '~~', '~~') },
    { label: 'H', title: 'Заголовок 2', run: (ta) => mdInsertLinePrefix(ta, '## ') },
    { label: '•', title: 'Список', run: (ta) => mdInsertLinePrefix(ta, '- ') },
    { label: '1.', title: 'Нумерованный', run: (ta) => mdInsertLinePrefix(ta, '1. ') },
    { label: '❝', title: 'Цитата', run: (ta) => mdInsertLinePrefix(ta, '> ') },
    { label: '`', title: 'Код', run: (ta) => mdWrapSelection(ta, '`', '`') },
    { label: '{}', title: 'Блок кода', run: (ta) => mdWrapSelection(ta, '```\n', '\n```', 'code') },
    {
      label: '🔗',
      title: 'Ссылка',
      run: async (ta) => {
        const url = await mdPromptUrl('URL ссылки');
        if (!url) return;
        mdWrapSelection(ta, '[', `](${url})`, 'текст');
      },
    },
    { label: '⊞', title: 'Таблица', run: (ta) => mdInsertTable(ta) },
    {
      label: '🖼',
      title: 'Картинка',
      run: async (ta) => {
        const url = await mdPromptUrl('URL картинки');
        if (!url) return;
        mdWrapSelection(ta, '![', `](${url})`, 'описание');
      },
    },
    { label: '—', title: 'Разделитель', run: (ta) => mdInsertBlock(ta, '---') },
  ];

  document.querySelectorAll('.md-toolbar[data-md-target]').forEach((bar) => {
    const targetId = bar.dataset.mdTarget;
    const textarea = document.getElementById(targetId);
    if (!textarea) return;
    bar.innerHTML = actions
      .map(
        (a, i) =>
          `<button type="button" class="md-tool" data-md-action="${i}" title="${esc(a.title)}">${a.label}</button>`,
      )
      .join('');
    bar.querySelectorAll('.md-tool').forEach((btn) => {
      btn.addEventListener('click', () => {
        const action = actions[Number(btn.dataset.mdAction)];
        action?.run(textarea);
      });
    });
  });
}

function refreshPreview(textareaId, previewId, coverUrl) {
  const ta = document.getElementById(textareaId);
  const preview = document.getElementById(previewId);
  if (!ta || !preview) return;
  preview.innerHTML = renderMarkdown(ta.value, coverUrl);
}

function setupEditorTabs(scope) {
  const root = scope === 'compose'
    ? document.getElementById('view-compose')
    : document.getElementById('article-dialog');
  if (!root) return;

  root.querySelectorAll('.editor-tab').forEach((tab) => {
    tab.addEventListener('click', () => {
      root.querySelectorAll('.editor-tab').forEach((t) => t.classList.remove('active'));
      tab.classList.add('active');
      const target = tab.dataset.editor;
      const isPreview = target.includes('preview');
      const textarea = root.querySelector('textarea');
      const preview = root.querySelector('.md-preview');
      if (textarea) textarea.classList.toggle('hidden', isPreview);
      if (preview) preview.classList.toggle('hidden', !isPreview);
      if (isPreview && textarea && preview) {
        const coverUrl = scope === 'compose'
          ? coverPreviewSrc('compose')
          : coverPreviewSrc('dialog');
        preview.innerHTML = renderMarkdown(textarea.value, coverUrl);
      }
    });
  });

  const textarea = root.querySelector('textarea');
  if (textarea) {
    textarea.addEventListener('input', () => {
      const preview = root.querySelector('.md-preview');
      if (preview && !preview.classList.contains('hidden')) {
        const coverUrl = scope === 'compose'
          ? coverPreviewSrc('compose')
          : coverPreviewSrc('dialog');
        preview.innerHTML = renderMarkdown(textarea.value, coverUrl);
      }
    });
  }
}

function coverPreviewSrc(key) {
  const st = coverState[key];
  if (st.file && st.objectUrl) return st.objectUrl;
  if (!st.clear && st.existingUrl) return mediaUrl(st.existingUrl);
  return null;
}

function setCoverPreview(key, previewId, clearBtnId) {
  const st = coverState[key];
  const el = document.getElementById(previewId);
  const clearBtn = document.getElementById(clearBtnId);
  const src = coverPreviewSrc(key);
  if (src) {
    el.classList.remove('empty');
    el.innerHTML = `<img src="${esc(src)}" alt="Обложка" />`;
    clearBtn?.classList.remove('hidden');
  } else {
    el.classList.add('empty');
    el.innerHTML = '<span>Перетащите обложку или нажмите для выбора</span>';
    clearBtn?.classList.add('hidden');
  }
}

function resetCoverState(key, previewId, clearBtnId) {
  const st = coverState[key];
  if (st.objectUrl) URL.revokeObjectURL(st.objectUrl);
  coverState[key] = { file: null, objectUrl: null, existingUrl: null, clear: false };
  setCoverPreview(key, previewId, clearBtnId);
}

function pickCoverFile(key, file, previewId, clearBtnId) {
  if (!file || !file.type.startsWith('image/')) return;
  if (file.size > 2 * 1024 * 1024) {
    alert('Обложка до 2 МБ');
    return;
  }
  const st = coverState[key];
  if (st.objectUrl) URL.revokeObjectURL(st.objectUrl);
  st.file = file;
  st.objectUrl = URL.createObjectURL(file);
  st.clear = false;
  setCoverPreview(key, previewId, clearBtnId);
}

function setupCoverDrop({ key, dropId, inputId, previewId, clearBtnId }) {
  const drop = document.getElementById(dropId);
  const input = document.getElementById(inputId);
  const clearBtn = document.getElementById(clearBtnId);
  if (!drop || !input) return;

  drop.addEventListener('click', () => input.click());
  input.addEventListener('change', () => {
    if (input.files?.[0]) pickCoverFile(key, input.files[0], previewId, clearBtnId);
    input.value = '';
  });
  drop.addEventListener('dragover', (e) => {
    e.preventDefault();
    drop.classList.add('dragover');
  });
  drop.addEventListener('dragleave', () => drop.classList.remove('dragover'));
  drop.addEventListener('drop', (e) => {
    e.preventDefault();
    drop.classList.remove('dragover');
    const file = e.dataTransfer?.files?.[0];
    if (file) pickCoverFile(key, file, previewId, clearBtnId);
  });
  clearBtn?.addEventListener('click', (e) => {
    e.stopPropagation();
    const st = coverState[key];
    if (st.objectUrl) URL.revokeObjectURL(st.objectUrl);
    st.file = null;
    st.objectUrl = null;
    st.clear = true;
    setCoverPreview(key, previewId, clearBtnId);
  });
}

async function fileToBase64(file) {
  const buf = await file.arrayBuffer();
  let binary = '';
  const bytes = new Uint8Array(buf);
  for (let i = 0; i < bytes.length; i += 1) binary += String.fromCharCode(bytes[i]);
  return btoa(binary);
}

async function uploadCoverIfNeeded(articleId, key) {
  const st = coverState[key];
  if (!st.file) return;
  await api(`/v1/admin/articles/${articleId}/cover`, {
    method: 'POST',
    body: JSON.stringify({
      contentType: st.file.type || 'image/jpeg',
      data: await fileToBase64(st.file),
    }),
  });
}

function showLogin() {
  document.getElementById('login-screen').classList.remove('hidden');
  document.getElementById('app').classList.add('hidden');
}

function showApp() {
  document.getElementById('login-screen').classList.add('hidden');
  document.getElementById('app').classList.remove('hidden');
  document.getElementById('admin-info').textContent =
    `${state.profile.displayName || state.profile.login} · ${roleLabel(state.profile.role)}`;
  applyRoleNav();
}

function applyRoleNav() {
  const role = state.profile?.role || '';
  const navAccess = {
    dashboard: true,
    articles: canEditRole(role),
    compose: canEditRole(role),
    moderation: canModerateRole(role),
    users: isFullAdminRole(role),
    audit: isFullAdminRole(role),
    settings: isFullAdminRole(role),
  };

  document.querySelectorAll('.nav-item[data-view]').forEach((btn) => {
    btn.classList.toggle('hidden-nav', !navAccess[btn.dataset.view]);
  });

  if (!navAccess[state.currentView]) {
    if (canModerateRole(role)) setView('moderation');
    else if (canEditRole(role)) setView('articles');
    else setView('dashboard');
  }
}

function setView(name) {
  state.currentView = name;
  document.querySelectorAll('.nav-item').forEach((el) => {
    el.classList.toggle('active', el.dataset.view === name);
  });
  document.querySelectorAll('.view').forEach((el) => el.classList.add('hidden'));
  document.getElementById(`view-${name}`)?.classList.remove('hidden');

  const titles = {
    dashboard: 'Дашборд',
    articles: 'Все статьи',
    compose: 'Написать статью',
    moderation: 'Модерация',
    users: 'Пользователи',
    audit: 'Журнал аудита',
    settings: 'Настройки сервера',
  };
  document.getElementById('view-title').textContent = titles[name] || name;
  refreshCurrentView();
}

async function refreshCurrentView() {
  try {
    switch (state.currentView) {
      case 'dashboard':
        await loadDashboard();
        break;
      case 'articles':
        await loadArticles();
        break;
      case 'moderation':
        await loadModeration();
        break;
      case 'users':
        await loadUsers();
        break;
      case 'audit':
        await loadAudit();
        break;
      case 'settings':
        await loadSettings();
        break;
    }
    await updatePendingBadge();
  } catch (e) {
    if (e.status === 401 || e.status === 403) {
      clearSession();
      showLogin();
    } else {
      console.error(e);
      alert(`Ошибка: ${e.message || e}`);
    }
  }
}

async function updatePendingBadge() {
  try {
    const data = await api('/v1/admin/dashboard');
    const n = data.dashboard?.articles?.pending ?? 0;
    const badge = document.getElementById('pending-badge');
    badge.textContent = n;
    badge.classList.toggle('hidden', n === 0);
  } catch {
    /* ignore */
  }
}

async function loadDashboard() {
  const { dashboard } = await api('/v1/admin/dashboard');
  const s = dashboard.articles;
  document.getElementById('stats-grid').innerHTML = `
    <div class="stat-card"><div class="label">Пользователи</div><div class="value">${dashboard.users}</div></div>
    <div class="stat-card"><div class="label">Статей всего</div><div class="value">${s.total}</div></div>
    <div class="stat-card"><div class="label">На модерации</div><div class="value">${s.pending}</div></div>
    <div class="stat-card"><div class="label">Опубликовано</div><div class="value">${s.approved}</div></div>
    <div class="stat-card"><div class="label">Чатов</div><div class="value">${dashboard.threads}</div></div>
    <div class="stat-card"><div class="label">Сообщений</div><div class="value">${dashboard.messages}</div></div>
  `;

  const rows = (dashboard.recentAudit || [])
    .map(
      (l) => `<tr>
        <td>${fmtDate(l.createdAt)}</td>
        <td><code>${l.action}</code></td>
        <td>${l.userLogin || l.userName || '—'}</td>
      </tr>`,
    )
    .join('');
  document.getElementById('recent-audit').innerHTML = `
    <table><thead><tr><th>Время</th><th>Действие</th><th>Пользователь</th></tr></thead>
    <tbody>${rows || '<tr><td colspan="3">Пусто</td></tr>'}</tbody></table>`;
}

async function loadArticles() {
  const q = document.getElementById('articles-search').value.trim();
  const status = document.getElementById('articles-status').value;
  const params = new URLSearchParams({ limit: '100' });
  if (status !== 'all') params.set('status', status);
  if (q) params.set('q', q);

  const { articles } = await api(`/v1/admin/articles?${params}`);
  const rows = articles
    .map(
      (a) => `<tr>
        <td><input type="checkbox" class="batch-select" data-batch-scope="articles" value="${esc(a.id)}" /></td>
        <td>${statusBadge(a.status)} ${scheduleBadge(a)}${a.featured ? ' ⭐' : ''}</td>
        <td><strong>${esc(a.title)}</strong><br><span class="meta">${esc(categoryLabel(a.category))}</span></td>
        <td>${esc(a.authorLogin)}</td>
        <td>${fmtDate(a.publishAt || a.updatedAt)}</td>
        <td><button type="button" class="btn ghost sm" data-edit="${a.id}">Редактировать</button></td>
      </tr>`,
    )
    .join('');

  const el = document.getElementById('articles-list');
  el.innerHTML = `<table><thead><tr>
    <th><input type="checkbox" id="articles-select-all" title="Выбрать все" /></th>
    <th>Статус</th><th>Заголовок</th><th>Автор</th><th>Публикация</th><th></th>
  </tr></thead>
    <tbody>${rows || '<tr><td colspan="6">Нет статей</td></tr>'}</tbody></table>`;

  el.querySelectorAll('[data-edit]').forEach((btn) => {
    btn.addEventListener('click', () => openArticleEditor(btn.dataset.edit, articles));
  });
  setupBatchSelection('articles');
}

async function openArticleEditor(id, cached) {
  let article = cached?.find((a) => a.id === id);
  if (!article) {
    const data = await api(`/v1/articles/${id}`);
    article = data.article;
  }

  document.getElementById('dialog-article-id').value = article.id;
  document.getElementById('dialog-title-input').value = article.title;
  document.getElementById('dialog-body-input').value = article.body;
  document.getElementById('dialog-status').value = article.status;
  document.getElementById('dialog-publish-at').value = toDatetimeLocal(article.publishAt);
  document.getElementById('dialog-category').value = article.category || 'other';
  document.getElementById('dialog-tags').value = (article.tags || []).join(', ');
  document.getElementById('dialog-featured').checked = Boolean(article.featured);
  coverState.dialog = {
    file: null,
    objectUrl: null,
    existingUrl: article.coverUrl || null,
    clear: false,
  };
  setCoverPreview('dialog', 'dialog-cover-preview', 'dialog-cover-clear');
  document.getElementById('article-dialog').querySelectorAll('.editor-tab').forEach((t, i) => {
    t.classList.toggle('active', i === 0);
  });
  document.getElementById('dialog-body-input').classList.remove('hidden');
  document.getElementById('dialog-preview').classList.add('hidden');
  document.getElementById('dialog-unpublish').classList.toggle(
    'hidden',
    article.status !== 'approved',
  );
  document.getElementById('dialog-versions-panel').open = false;
  document.getElementById('dialog-versions-list').innerHTML =
    'Откройте раздел для загрузки…';
  document.getElementById('dialog-versions-panel').ontoggle = () => {
    if (document.getElementById('dialog-versions-panel').open) {
      loadArticleVersions(article.id);
    }
  };
  document.getElementById('article-dialog').showModal();
}

async function loadArticleVersions(articleId) {
  const el = document.getElementById('dialog-versions-list');
  el.innerHTML = 'Загрузка…';
  try {
    const { versions } = await api(`/v1/admin/articles/${articleId}/versions?limit=30`);
    if (!versions.length) {
      el.innerHTML =
        '<p class="hint">История пуста — версии появятся после первого сохранения.</p>';
      return;
    }
    el.innerHTML = `<table class="versions-table"><thead><tr><th>#</th><th>Дата</th><th>Источник</th><th>Заголовок</th><th></th></tr></thead><tbody>${versions
      .map(
        (v) => `<tr>
        <td>v${v.versionNumber}</td>
        <td>${fmtDate(v.createdAt)}</td>
        <td>${esc(versionSourceLabel(v.source))}</td>
        <td>${esc(v.title.slice(0, 80))}${v.title.length > 80 ? '…' : ''}</td>
        <td>
          <button type="button" class="btn ghost sm" data-preview-version="${v.id}">Просмотр</button>
          <button type="button" class="btn ghost sm" data-rollback-version="${v.id}">Откатить</button>
        </td>
      </tr>`,
      )
      .join('')}</tbody></table>`;
    el.querySelectorAll('[data-preview-version]').forEach((btn) => {
      btn.addEventListener('click', () =>
        previewArticleVersion(articleId, btn.dataset.previewVersion),
      );
    });
    el.querySelectorAll('[data-rollback-version]').forEach((btn) => {
      btn.addEventListener('click', () =>
        rollbackArticleVersion(articleId, btn.dataset.rollbackVersion),
      );
    });
  } catch (e) {
    el.innerHTML = `<p class="error">Ошибка: ${esc(e.code || e.message)}</p>`;
  }
}

async function previewArticleVersion(articleId, versionId) {
  const { version } = await api(
    `/v1/admin/articles/${articleId}/versions/${versionId}`,
  );
  document.getElementById('version-preview-title').textContent =
    `v${version.versionNumber}: ${version.title}`;
  document.getElementById('version-preview-meta').textContent =
    `${versionSourceLabel(version.source)} · ${version.createdByLogin || '—'} · ${fmtDate(version.createdAt)}`;
  document.getElementById('version-preview-body').innerHTML = renderMarkdown(
    version.body,
    version.coverUrl,
  );
  document.getElementById('version-preview-dialog').showModal();
}

async function rollbackArticleVersion(articleId, versionId) {
  if (
    !confirm(
      'Откатить статью к этой версии? Текущее состояние будет сохранено в истории.',
    )
  ) {
    return;
  }
  const { article } = await api(`/v1/admin/articles/${articleId}/rollback`, {
    method: 'POST',
    body: JSON.stringify({ versionId }),
  });
  document.getElementById('dialog-title-input').value = article.title;
  document.getElementById('dialog-body-input').value = article.body;
  document.getElementById('dialog-status').value = article.status;
  document.getElementById('dialog-publish-at').value = toDatetimeLocal(article.publishAt);
  document.getElementById('dialog-category').value = article.category || 'other';
  document.getElementById('dialog-tags').value = (article.tags || []).join(', ');
  document.getElementById('dialog-featured').checked = Boolean(article.featured);
  coverState.dialog = {
    file: null,
    objectUrl: null,
    existingUrl: article.coverUrl || null,
    clear: false,
  };
  setCoverPreview('dialog', 'dialog-cover-preview', 'dialog-cover-clear');
  document.getElementById('dialog-unpublish').classList.toggle(
    'hidden',
    article.status !== 'approved',
  );
  await loadArticleVersions(articleId);
  alert('Статья откачена к выбранной версии.');
}

async function loadModeration() {
  const { articles } = await api('/v1/admin/articles/pending');
  const el = document.getElementById('moderation-list');
  if (!articles.length) {
    el.innerHTML = '<p class="hint">Очередь модерации пуста 🎉</p>';
    updateBatchToolbar('moderation');
    return;
  }

  el.innerHTML = `
    <label class="checkbox moderation-select-all">
      <input type="checkbox" id="moderation-select-all" /> Выбрать все (${articles.length})
    </label>
    ${articles
      .map(
        (a) => `<article class="card card-select">
        <input type="checkbox" class="batch-select" data-batch-scope="moderation" value="${esc(a.id)}" />
        <div class="card-body">
          <h4>${esc(a.title)}</h4>
          <div class="meta">${esc(a.authorLogin)} · ${fmtDate(a.createdAt)}</div>
          <div class="preview">${esc(a.body.slice(0, 280))}${a.body.length > 280 ? '…' : ''}</div>
          <div class="card-actions">
            <button type="button" class="btn primary sm" data-approve="${a.id}">✓ Одобрить</button>
            <button type="button" class="btn danger sm" data-reject="${a.id}">✕ Отклонить</button>
            <button type="button" class="btn ghost sm" data-edit-mod="${a.id}">Редактировать</button>
          </div>
        </div>
      </article>`,
      )
      .join('')}`;

  el.querySelectorAll('[data-approve]').forEach((btn) => {
    btn.addEventListener('click', async () => {
      await api(`/v1/admin/articles/${btn.dataset.approve}/approve`, { method: 'POST' });
      await loadModeration();
      await updatePendingBadge();
    });
  });

  el.querySelectorAll('[data-reject]').forEach((btn) => {
    btn.addEventListener('click', async () => {
      const reason = prompt('Причина отклонения (необязательно):') || '';
      await api(`/v1/admin/articles/${btn.dataset.reject}/reject`, {
        method: 'POST',
        body: JSON.stringify({ reason }),
      });
      await loadModeration();
      await updatePendingBadge();
    });
  });

  el.querySelectorAll('[data-edit-mod]').forEach((btn) => {
    btn.addEventListener('click', () => openArticleEditor(btn.dataset.editMod, articles));
  });
  setupBatchSelection('moderation');
}

function selectedBatchIds(scope) {
  return [
    ...document.querySelectorAll(
      `input.batch-select[data-batch-scope="${scope}"]:checked`,
    ),
  ].map((cb) => cb.value);
}

function updateBatchToolbar(scope) {
  const ids = selectedBatchIds(scope);
  const toolbar = document.getElementById(`${scope}-batch-toolbar`);
  const countEl = document.getElementById(`${scope}-batch-count`);
  if (!toolbar || !countEl) return;
  countEl.textContent = `${ids.length} выбрано`;
  toolbar.classList.toggle('hidden', ids.length === 0);
}

function setupBatchSelection(scope) {
  updateBatchToolbar(scope);
  document.querySelectorAll(`input.batch-select[data-batch-scope="${scope}"]`).forEach((cb) => {
    cb.addEventListener('change', () => updateBatchToolbar(scope));
  });
  const selectAll = document.getElementById(`${scope}-select-all`);
  if (selectAll) {
    selectAll.checked = false;
    selectAll.onchange = () => {
      const checked = selectAll.checked;
      document
        .querySelectorAll(`input.batch-select[data-batch-scope="${scope}"]`)
        .forEach((cb) => {
          cb.checked = checked;
        });
      updateBatchToolbar(scope);
    };
  }
}

async function runBatchAction(action, ids, { reason, confirmText } = {}) {
  if (!ids.length) return null;
  if (confirmText && !confirm(confirmText)) return null;
  const body = { ids };
  if (reason != null) body.reason = reason;
  return api(`/v1/admin/articles/batch/${action}`, {
    method: 'POST',
    body: JSON.stringify(body),
  });
}

function showBatchResult(result, actionLabel) {
  const failed = result.failedCount || 0;
  const processed = result.processed || 0;
  let msg = `${actionLabel}: успешно ${processed}`;
  if (failed > 0) {
    const details = (result.failed || [])
      .slice(0, 5)
      .map((f) => `${f.id.slice(0, 8)}… (${f.error})`)
      .join(', ');
    msg += `, ошибок ${failed}${details ? `: ${details}` : ''}`;
  }
  alert(msg);
}

async function loadUsers() {
  const q = document.getElementById('users-search').value.trim();
  const params = q ? `?q=${encodeURIComponent(q)}` : '';
  const { users } = await api(`/v1/admin/users${params}`);

  const rows = users
    .map(
      (u) => `<tr>
        <td>${esc(u.login)}</td>
        <td>${esc(u.displayName)}</td>
        <td>
          <select class="role-select" data-role-user="${u.id}" ${isFullAdminRole(state.profile?.role) ? '' : 'disabled'}>
            <option value="" ${!u.role ? 'selected' : ''}>—</option>
            <option value="moderator" ${u.role === 'moderator' ? 'selected' : ''}>Модератор</option>
            <option value="editor" ${u.role === 'editor' ? 'selected' : ''}>Редактор</option>
            <option value="admin" ${u.role === 'admin' ? 'selected' : ''}>Админ</option>
          </select>
        </td>
        <td>${u.articleCount}</td>
        <td>${fmtDate(u.createdAt)}</td>
      </tr>`,
    )
    .join('');

  const el = document.getElementById('users-list');
  el.innerHTML = `<table><thead><tr><th>Логин</th><th>Имя</th><th>Роль</th><th>Статей</th><th>Регистрация</th></tr></thead>
    <tbody>${rows || '<tr><td colspan="5">Нет пользователей</td></tr>'}</tbody></table>`;

  el.querySelectorAll('[data-role-user]').forEach((select) => {
    select.addEventListener('change', async () => {
      const userId = select.dataset.roleUser;
      const role = select.value;
      if (!confirm(`Назначить роль «${roleLabel(role || '')}»?`)) {
        await loadUsers();
        return;
      }
      await api(`/v1/admin/users/${userId}`, {
        method: 'PATCH',
        body: JSON.stringify({ role }),
      });
      await loadUsers();
    });
  });
}

async function loadAudit() {
  const { logs } = await api('/v1/admin/audit?limit=100');
  const rows = logs
    .map(
      (l) => `<tr>
        <td>${fmtDate(l.createdAt)}</td>
        <td><code>${esc(l.action)}</code></td>
        <td>${esc(l.userLogin || '—')}</td>
        <td><small>${esc(l.meta || '')}</small></td>
      </tr>`,
    )
    .join('');

  document.getElementById('audit-list').innerHTML = `
    <table><thead><tr><th>Время</th><th>Действие</th><th>Пользователь</th><th>Meta</th></tr></thead>
    <tbody>${rows || '<tr><td colspan="4">Пусто</td></tr>'}</tbody></table>`;
}

async function loadSettings() {
  const { settings } = await api('/v1/admin/settings');
  document.getElementById('setting-min-version').value = settings.minAppVersion || '';
  document.getElementById('setting-admin-logins').value = settings.adminLogins || '';
  await loadBackups();
}

function formatBytes(n) {
  if (n == null) return '—';
  if (n < 1024) return `${n} B`;
  if (n < 1024 * 1024) return `${(n / 1024).toFixed(1)} KB`;
  return `${(n / (1024 * 1024)).toFixed(1)} MB`;
}

async function loadBackups() {
  const statusEl = document.getElementById('backup-status');
  const listEl = document.getElementById('backup-list');
  if (!statusEl || !listEl) return;

  try {
    const { status, backups } = await api('/v1/admin/backups');
    statusEl.textContent =
      `Бэкенд: ${status.backend} · интервал ${status.intervalHours}ч · хранится до ${status.maxCount} · всего ${status.count}`;
    const rows = (backups || [])
      .map(
        (b) => `<tr>
          <td><code>${esc(b.id)}</code></td>
          <td>${esc(b.createdAt)}</td>
          <td>${esc(b.source)}</td>
          <td>${formatBytes(b.sizeBytes)}</td>
          <td>
            <button type="button" class="btn ghost sm" data-backup-download="${b.id}">Скачать</button>
            <button type="button" class="btn ghost sm" data-backup-restore="${b.id}">Восстановить</button>
            <button type="button" class="btn danger sm" data-backup-delete="${b.id}">Удалить</button>
          </td>
        </tr>`,
      )
      .join('');
    listEl.innerHTML = `<table><thead><tr><th>ID</th><th>Дата</th><th>Источник</th><th>Размер</th><th></th></tr></thead>
      <tbody>${rows || '<tr><td colspan="5">Снимков пока нет</td></tr>'}</tbody></table>`;
  } catch (e) {
    statusEl.textContent = `Ошибка загрузки: ${e.message}`;
    listEl.innerHTML = '';
  }
}

function esc(s) {
  return String(s ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

document.getElementById('login-form').addEventListener('submit', async (e) => {
  e.preventDefault();
  const errEl = document.getElementById('login-error');
  errEl.classList.add('hidden');

  state.baseUrl = document.getElementById('server-url').value.trim() || defaultBaseUrl();
  const login = document.getElementById('login-input').value.trim();
  const password = document.getElementById('password-input').value;

  try {
    const auth = await api('/v1/auth/login', {
      method: 'POST',
      body: JSON.stringify({ login, password, deviceName: 'EcoPulse Admin Web' }),
    });

    if (!auth.isStaff) {
      throw new Error('Нужна staff-роль: moderator, editor или admin');
    }

    state.token = auth.token;
    state.profile = {
      login: auth.login,
      displayName: auth.displayName,
      role: auth.role || '',
      isStaff: auth.isStaff,
      isAdmin: auth.isAdmin,
    };
    saveSession();
    showApp();
    if (canModerateRole(auth.role)) setView('moderation');
    else if (canEditRole(auth.role)) setView('articles');
    else setView('dashboard');
  } catch (err) {
    if (err.code === 'rate_limit_exceeded' && err.retryAfterSeconds) {
      errEl.textContent = `Слишком много попыток. Повторите через ${err.retryAfterSeconds} с.`;
    } else {
      errEl.textContent = err.message || 'Ошибка входа';
    }
    errEl.classList.remove('hidden');
  }
});

document.getElementById('logout-btn').addEventListener('click', async () => {
  try {
    await api('/v1/auth/logout', { method: 'POST' });
  } catch {
    /* ignore */
  }
  clearSession();
  showLogin();
});

document.querySelectorAll('.nav-item').forEach((btn) => {
  btn.addEventListener('click', () => setView(btn.dataset.view));
});

document.getElementById('refresh-btn').addEventListener('click', () => refreshCurrentView());

document.getElementById('articles-search').addEventListener(
  'input',
  debounce(() => loadArticles(), 350),
);
document.getElementById('articles-status').addEventListener('change', () => loadArticles());
document.getElementById('users-search').addEventListener(
  'input',
  debounce(() => loadUsers(), 350),
);

document.getElementById('compose-save').addEventListener('click', async () => {
  const title = document.getElementById('compose-title').value.trim();
  const body = document.getElementById('compose-body').value.trim();
  const publishNow = document.getElementById('compose-publish').checked;
  const publishAtLocal = document.getElementById('compose-publish-at').value;
  const publishAt = toIsoPublishAt(publishAtLocal);
  const msg = document.getElementById('compose-msg');

  try {
    const { article } = await api('/v1/admin/articles', {
      method: 'POST',
      body: JSON.stringify({
        title,
        body,
        publish: publishNow || Boolean(publishAt),
        publishAt,
        category: document.getElementById('compose-category').value,
        tags: parseTagsInput(document.getElementById('compose-tags').value),
        featured: document.getElementById('compose-featured').checked,
      }),
    });
    await uploadCoverIfNeeded(article.id, 'compose');
    if (publishAt && new Date(publishAt) > new Date()) {
      msg.textContent = `Запланировано на ${fmtDate(publishAt)}`;
    } else {
      msg.textContent = publishNow ? 'Статья опубликована!' : 'Черновик сохранён (на модерации).';
    }
    document.getElementById('compose-title').value = '';
    document.getElementById('compose-body').value = '';
    document.getElementById('compose-publish-at').value = '';
    document.getElementById('compose-category').value = 'other';
    document.getElementById('compose-tags').value = '';
    document.getElementById('compose-featured').checked = false;
    resetCoverState('compose', 'compose-cover-preview', 'compose-cover-clear');
    await updatePendingBadge();
  } catch (e) {
    msg.textContent = `Ошибка: ${e.code || e.message}`;
  }
});

document.getElementById('article-form').addEventListener('submit', async (e) => {
  e.preventDefault();
  const id = document.getElementById('dialog-article-id').value;
  const title = document.getElementById('dialog-title-input').value.trim();
  const body = document.getElementById('dialog-body-input').value.trim();
  const status = document.getElementById('dialog-status').value;
  const publishAt = toIsoPublishAt(document.getElementById('dialog-publish-at').value);

  await api(`/v1/admin/articles/${id}`, {
    method: 'PATCH',
    body: JSON.stringify({
      title,
      body,
      status,
      publishAt: publishAt || '',
      clearCover: coverState.dialog.clear,
      category: document.getElementById('dialog-category').value,
      tags: parseTagsInput(document.getElementById('dialog-tags').value),
      featured: document.getElementById('dialog-featured').checked,
    }),
  });
  await uploadCoverIfNeeded(id, 'dialog');
  document.getElementById('article-dialog').close();
  await refreshCurrentView();
});

document.getElementById('dialog-delete').addEventListener('click', async () => {
  const id = document.getElementById('dialog-article-id').value;
  if (!confirm('Удалить статью безвозвратно?')) return;
  await api(`/v1/admin/articles/${id}`, { method: 'DELETE' });
  document.getElementById('article-dialog').close();
  await refreshCurrentView();
});

document.getElementById('dialog-unpublish').addEventListener('click', async () => {
  const id = document.getElementById('dialog-article-id').value;
  const reason = prompt('Причина снятия с публикации:') || '';
  await api(`/v1/admin/articles/${id}/unpublish`, {
    method: 'POST',
    body: JSON.stringify({ reason }),
  });
  document.getElementById('article-dialog').close();
  await refreshCurrentView();
});

document.getElementById('settings-save').addEventListener('click', async () => {
  const msg = document.getElementById('settings-msg');
  try {
    await api('/v1/admin/settings', {
      method: 'PATCH',
      body: JSON.stringify({
        minAppVersion: document.getElementById('setting-min-version').value.trim(),
        adminLogins: document.getElementById('setting-admin-logins').value.trim(),
      }),
    });
    msg.textContent = 'Настройки сохранены';
  } catch (e) {
    msg.textContent = `Ошибка: ${e.message}`;
  }
});

function debounce(fn, ms) {
  let t;
  return (...args) => {
    clearTimeout(t);
    t = setTimeout(() => fn(...args), ms);
  };
}

document.getElementById('server-url').value = defaultBaseUrl();

setupEditorTabs('compose');
setupEditorTabs('dialog');
setupMarkdownToolbars();
setupCoverDrop({
  key: 'compose',
  dropId: 'compose-cover-drop',
  inputId: 'compose-cover-input',
  previewId: 'compose-cover-preview',
  clearBtnId: 'compose-cover-clear',
});
setupCoverDrop({
  key: 'dialog',
  dropId: 'dialog-cover-drop',
  inputId: 'dialog-cover-input',
  previewId: 'dialog-cover-preview',
  clearBtnId: 'dialog-cover-clear',
});

document.getElementById('version-preview-close').addEventListener('click', () => {
  document.getElementById('version-preview-dialog').close();
});

document.getElementById('articles-batch-approve').addEventListener('click', async () => {
  const ids = selectedBatchIds('articles');
  const result = await runBatchAction('approve', ids);
  if (!result) return;
  showBatchResult(result, 'Одобрение');
  await loadArticles();
  await updatePendingBadge();
});

document.getElementById('articles-batch-reject').addEventListener('click', async () => {
  const ids = selectedBatchIds('articles');
  if (!ids.length) return;
  const reason = prompt('Причина отклонения для всех выбранных (необязательно):') ?? null;
  if (reason === null) return;
  const result = await runBatchAction('reject', ids, { reason });
  if (!result) return;
  showBatchResult(result, 'Отклонение');
  await loadArticles();
  await updatePendingBadge();
});

document.getElementById('articles-batch-delete').addEventListener('click', async () => {
  const ids = selectedBatchIds('articles');
  const result = await runBatchAction('delete', ids, {
    confirmText: `Удалить ${ids.length} статей безвозвратно?`,
  });
  if (!result) return;
  showBatchResult(result, 'Удаление');
  await loadArticles();
  await updatePendingBadge();
});

document.getElementById('moderation-batch-approve').addEventListener('click', async () => {
  const ids = selectedBatchIds('moderation');
  const result = await runBatchAction('approve', ids);
  if (!result) return;
  showBatchResult(result, 'Одобрение');
  await loadModeration();
  await updatePendingBadge();
});

document.getElementById('moderation-batch-reject').addEventListener('click', async () => {
  const ids = selectedBatchIds('moderation');
  if (!ids.length) return;
  const reason = prompt('Причина отклонения для всех выбранных (необязательно):') ?? null;
  if (reason === null) return;
  const result = await runBatchAction('reject', ids, { reason });
  if (!result) return;
  showBatchResult(result, 'Отклонение');
  await loadModeration();
  await updatePendingBadge();
});

document.getElementById('backup-create')?.addEventListener('click', async () => {
  try {
    await api('/v1/admin/backups', { method: 'POST', body: '{}' });
    await loadBackups();
  } catch (e) {
    alert(`Не удалось создать снимок: ${e.message}`);
  }
});

document.getElementById('backup-list')?.addEventListener('click', async (e) => {
  const dlBtn = e.target.closest('[data-backup-download]');
  if (dlBtn) {
    const id = dlBtn.dataset.backupDownload;
    const url = `${state.baseUrl.replace(/\/$/, '')}/v1/admin/backups/${id}/download`;
    const res = await fetch(url, {
      headers: { Authorization: `Bearer ${state.token}` },
    });
    if (!res.ok) {
      alert('Ошибка скачивания');
      return;
    }
    const blob = await res.blob();
    const a = document.createElement('a');
    a.href = URL.createObjectURL(blob);
    a.download = `ecopulse_${id}.db`;
    a.click();
    URL.revokeObjectURL(a.href);
    return;
  }

  const restoreBtn = e.target.closest('[data-backup-restore]');
  if (restoreBtn) {
    const id = restoreBtn.dataset.backupRestore;
    if (!confirm(`Восстановить БД из снимка ${id}? Текущие данные будут перезаписаны.`)) return;
    try {
      await api(`/v1/admin/backups/${id}/restore`, { method: 'POST', body: '{}' });
      alert('База восстановлена.');
      await loadBackups();
    } catch (err) {
      alert(`Ошибка: ${err.message}`);
    }
    return;
  }

  const delBtn = e.target.closest('[data-backup-delete]');
  if (delBtn) {
    const id = delBtn.dataset.backupDelete;
    if (!confirm(`Удалить снимок ${id}?`)) return;
    try {
      await api(`/v1/admin/backups/${id}`, { method: 'DELETE' });
      await loadBackups();
    } catch (err) {
      alert(`Ошибка: ${err.message}`);
    }
  }
});

if (loadSession()) {
  showApp();
  setView('dashboard');
} else {
  showLogin();
}
