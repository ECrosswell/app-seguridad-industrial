import {
  cpSync,
  existsSync,
  mkdirSync,
  rmSync,
  writeFileSync,
} from 'node:fs';
import { join, resolve, sep } from 'node:path';

const projectRoot = process.cwd();
const flutterOutput = resolve(projectRoot, 'build', 'web');
const vercelOutput = resolve(projectRoot, '.vercel', 'output');
const staticOutput = join(vercelOutput, 'static');

if (!existsSync(join(flutterOutput, 'index.html'))) {
  throw new Error(
    'Missing build/web/index.html. Run the Flutter web build before packaging.',
  );
}

const expectedSuffix = `${sep}.vercel${sep}output`;
if (!vercelOutput.startsWith(`${projectRoot}${sep}`) ||
    !vercelOutput.endsWith(expectedSuffix)) {
  throw new Error(`Refusing to replace unexpected path: ${vercelOutput}`);
}

rmSync(vercelOutput, { recursive: true, force: true });
mkdirSync(staticOutput, { recursive: true });
cpSync(flutterOutput, staticOutput, { recursive: true });

const config = {
  version: 3,
  routes: [
    {
      src: '/(.*)',
      headers: {
        'X-Content-Type-Options': 'nosniff',
        'X-Frame-Options': 'DENY',
        'Referrer-Policy': 'strict-origin-when-cross-origin',
      },
      continue: true,
    },
    { handle: 'filesystem' },
    { src: '/.*', dest: '/index.html' },
  ],
};

writeFileSync(
  join(vercelOutput, 'config.json'),
  `${JSON.stringify(config, null, 2)}\n`,
  'utf8',
);

console.log(`Prepared ${staticOutput} for Vercel deployment.`);
