import bcrypt from 'bcryptjs';

const password = 'admin123';
const hash = await bcrypt.hash(password, 10);

console.log('Password hash para admin123:');
console.log(hash);
console.log('\nSQL Update:');
console.log(`UPDATE users SET password = '${hash}' WHERE email = 'admin@portfolio.com';`);
