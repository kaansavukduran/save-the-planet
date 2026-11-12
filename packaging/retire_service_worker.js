// One-time retirement of the archived Canvas/PWA workers. Never touch save storage.
self.addEventListener('install', event => event.waitUntil(self.skipWaiting()));
self.addEventListener('activate', event => event.waitUntil((async () => {
  await self.clients.claim();
  await caches.delete('save-the-planet-v1');
  const windows = await self.clients.matchAll({type: 'window'});
  const base = new URL(self.registration.scope);
  await self.registration.unregister();
  await Promise.allSettled(windows.filter(client => {
    const url = new URL(client.url);
    return url.origin === base.origin &&
      [base.pathname, base.pathname + 'index.html'].includes(url.pathname);
  }).map(client => client.navigate(new URL('play', base).href)));
})()));
