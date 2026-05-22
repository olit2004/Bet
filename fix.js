const fs = require('fs');

const files = [
  'backend/src/user/user.routes.js',
  'backend/src/user/user.controller.js',
  'backend/src/user/user.service.js',
  'backend/src/user/user.middleware.js'
];

files.forEach(f => {
  let c = fs.readFileSync(f, 'utf8');
  c = c.replace(/const (.*?) = require\(['"](.*?)['"]\);/g, 'import $1 from \'$2\';');
  c = c.replace(/module\.exports = \{ (.*?) \};/g, 'export { $1 };');
  c = c.replace(/module\.exports = (.*?);/g, 'export default $1;');
  
  // Fix imports
  c = c.replace(/'\.\/user\.service'/g, '\'./user.service.js\'');
  c = c.replace(/'\.\/user\.controller'/g, '\'./user.controller.js\'');
  c = c.replace(/'\.\.\/shared\/db'/g, '\'../shared/prisma.client.js\'');
  
  fs.writeFileSync(f, c);
  console.log('Converted', f);
});
