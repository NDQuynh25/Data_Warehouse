import sql from "mssql/msnodesqlv8";

const config: sql.config = {
  server: "localhost",
  database: "OLAP",
  driver: "msnodesqlv8",
  options: {
    trustedConnection: true,
  },
};

export const connectToDB = async () => {
  try {
    await sql.connect(config); // thiết lập kết nối pool mặc định
    console.log("✅ Connected to SQL Server with Windows Authentication");
  } catch (error) {
    console.error("❌ Database connection failed:", error);
  }
};


export default sql;
export { config };