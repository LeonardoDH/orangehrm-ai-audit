import { GitHub } from './github.js';
import { explore, automate, review } from './pipeline.js';
import { decide, schemas } from './ai.js';
const command = process.argv[2];
const provider = process.argv.includes('--rules') ? 'rules' : 'codex';
const publish = process.argv.includes('--publish');
const baseURL = process.env.ORANGEHRM_BASE_URL || 'https://opensource-demo.orangehrmlive.com';
const options = { provider, publish, baseURL };
try {
  if (!['doctor', 'explore', 'automate', 'review', 'pipeline'].includes(command)) throw new Error('Usage: node src/cli.js doctor|explore|automate|review|pipeline [--rules] [--publish]');
  if (publish && new URL(baseURL).hostname !== 'opensource-demo.orangehrmlive.com') throw new Error('Publishing fixture/custom-host findings is disabled');
  if (publish || ['automate', 'review', 'pipeline'].includes(command)) options.github = new GitHub();
  if (command === 'doctor') {
    console.log(await decide('revisor', { reproduced: false, observation: 'Configuration check; no product claim' }, schemas.revisor, options));
  } else {
    if (['explore', 'pipeline'].includes(command)) await explore(options);
    if (['automate', 'pipeline'].includes(command)) await automate(options);
    if (['review', 'pipeline'].includes(command)) await review(options);
  }
} catch (error) { console.error(error.message); process.exitCode = 1; }
