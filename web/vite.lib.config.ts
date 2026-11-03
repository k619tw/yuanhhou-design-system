import { fileURLToPath, URL } from 'node:url'
import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'

// Library build of the design system (`npm run build:lib`): ES module and one stylesheet in lib/.
// React stays a peer dependency. Types are emitted separately by `tsc -p tsconfig.lib.json`.
export default defineConfig({
  plugins: [react()],
  publicDir: false,
  build: {
    outDir: 'lib',
    emptyOutDir: false,
    lib: {
      entry: fileURLToPath(new URL('./src/index.ts', import.meta.url)),
      formats: ['es'],
      fileName: 'index',
      cssFileName: 'style',
    },
    rolldownOptions: {
      external: ['react', 'react-dom', 'react/jsx-runtime'],
    },
  },
})
