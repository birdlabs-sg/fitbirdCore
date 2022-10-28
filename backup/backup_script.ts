/* eslint-disable no-console */
import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();
import fs from 'fs';

async function loadBackup() {
  const rawSql = await fs.promises.readFile(
    './Cloud_SQL_Export_2022-10-02 (19_35_32).sql',
    {
      encoding: 'utf-8'
    }
  );
  const sqlReducedToStatements = rawSql
    .split('\n')
    .filter((line: string) => !line.startsWith('--')) // remove comments-only lines
    .join('\n')
    .replace(/\r\n|\n|\r/g, ' ') // remove newlines
    .replace(/\s+/g, ' '); // excess white space
  const sqlStatements = splitStringByNotQuotedSemicolon(sqlReducedToStatements);

  console.log('loading...');
  for (const sql of sqlStatements) {
    console.log(sql);
    await prisma.$executeRawUnsafe(sql);
  }
  console.log('loaded.');
}

loadBackup();

function splitStringByNotQuotedSemicolon(input: string) {
  const result = [];

  let currentSplitIndex = 0;
  let isInString = false;
  for (let i = 0; i < input.length; i++) {
    if (input[i] === "'") {
      // toggle isInString
      isInString = !isInString;
    }
    if (input[i] === ';' && !isInString) {
      result.push(input.substring(currentSplitIndex, i + 1));
      currentSplitIndex = i + 2;
    }
  }

  return result;
}
