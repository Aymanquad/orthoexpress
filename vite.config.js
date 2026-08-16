import { defineConfig } from 'vite'
import path from 'path'
import { fileURLToPath } from 'url'
import react from '@vitejs/plugin-react'

const rootDir = path.dirname(fileURLToPath(import.meta.url))
const stagingAssetsDir = path.resolve(rootDir, 'assets')

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
    open: true,
    watch: {
      // Root /assets is a raw upload drop folder (not Vite public assets).
      // Ignoring it prevents EBUSY crashes from Windows/editor .~tmp locks.
      ignored: [
        '**/flutter_app/**',
        '**/*.~tmp',
        '**/*.~tmp',
        (watchPath) => {
          const normalized = path.resolve(watchPath)
          return (
            normalized === stagingAssetsDir ||
            normalized.startsWith(stagingAssetsDir + path.sep)
          )
        },
      ],
    },
  },
})
