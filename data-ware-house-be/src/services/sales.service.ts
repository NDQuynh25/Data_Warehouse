// sales.service.ts
import sql from "../config/dbConfig";

export const fetchDataByTable = async (table: string, page: number, pageSize: number): Promise<{ data: any[]; totalRecords: number }> => {
  

  try {
    const request = new sql.Request();
    const offset = (page - 1) * pageSize;

    // Query lấy dữ liệu trang hiện tại với OFFSET-FETCH
    const dataResult = await request.query(`
      SELECT * FROM dbo.${table}
      ORDER BY (SELECT NULL) 
      
    `);

    // Query đếm tổng số bản ghi trong bảng
    const countResult = await request.query(`
      SELECT COUNT(*) AS total FROM dbo.${table}
    `);

    const totalRecords = countResult.recordset[0].total;
    return { data: dataResult.recordset, totalRecords };
  } catch (error) {
    throw new Error("Query failed: " + (error as Error).message);
  }
};
