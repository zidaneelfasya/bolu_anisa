const xlsx = require('xlsx');

const workbook = xlsx.readFile('laporan_example/LABA HARIAN.xlsx');
const sheetNameList = workbook.SheetNames;

for (const sheetName of sheetNameList) {
    const xlData = xlsx.utils.sheet_to_json(workbook.Sheets[sheetName], {header: 1});
    console.log(`\n--- ${sheetName} ---`);
    for (let i = 0; i < xlData.length; i++) {
        console.log(`Row ${i}: `, xlData[i]);
    }
}
