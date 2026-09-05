import react from '@vitejs/plugin-react';
import { defineConfig } from 'vite';

export default defineConfig(({ command }) => {
  if (command === 'serve') {
    return {
      plugins: [react()],
      server: { port: 43180, host: '0.0.0.0' },
    };
  }

  return {
    plugins: [react()],
    define: {
      'process.env.NODE_ENV': '"production"',
    },
    base: './',
    build: {
      outDir: '../app/web/earth',
      emptyOutDir: true,
      sourcemap: false,
      lib: {
        entry: 'src/index.ts',
        name: 'CosmicEarthCanvas',
        formats: ['iife'],
        fileName: () => 'earth-canvas.js',
      },
      rollupOptions: {
        output: {
          assetFileNames: '[name][extname]',
        },
      },
    },
  };
});
