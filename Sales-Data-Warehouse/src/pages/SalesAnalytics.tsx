import React, { useState, useEffect } from "react";
import DimensionsSelector from "../components/DimensionSelector";
import DataTable from "../components/DataTable";
import { Container, Typography, Box, Paper } from "@mui/material";
import { getSalesData } from "../api/salesApi";

const dimensionsInitialState = {
  time: { show: false, columns: { year: false, quarter: false, month: false } },
  product: { show: false },
  store: { show: false },
  customer: {
    show: false,
    columns: { customerType: false, customerKey: false },
  },
  location: { show: false, columns: { state: false, city: false } },
};

const SalesAnalytics: React.FC = () => {
  const [dimensions, setDimensions] = useState(dimensionsInitialState);
  const [data, setData] = useState<any[]>([]);

  // Load cấu hình chiều từ localStorage nếu có

  // Mỗi khi dimensions thay đổi, fetch lại dữ liệu
  useEffect(() => {
    const fetchData = async () => {
      const tableName = getTableNameFromDimensions(dimensions);
      console.log("Fetching data for table:", tableName);
      try {
        const res = await getSalesData(tableName);
        console.log("Dữ liệu đã được fetch:", res);
        setData(res.data); // Giả sử `res` là mảng dữ liệu phù hợp
      } catch (error) {
        console.error("Lỗi khi fetch dữ liệu:", error);
        setData([]);
      }
    };
    fetchData();
  }, [dimensions]);

  const getTableNameFromDimensions = (
    dimensions: typeof dimensionsInitialState
  ) => {
    let tableName = "";
    let count = 0;

    if (dimensions.time.show) {
      count++;
      if (dimensions.time.columns.year) tableName += "_Year";
      if (dimensions.time.columns.quarter) tableName += "_Quarter";
      if (dimensions.time.columns.month) tableName += "_Month";
      if (tableName === "_Year_Month") tableName = "_Year_Quarter_Month";
    }
    if (dimensions.product.show) {
      count++;
      tableName += "_Product";
    }
    if (dimensions.store.show) {
      count++;
      tableName += "_Store";
    }
    if (dimensions.customer.show) {
      count++;
      if (
        dimensions.customer.columns.customerType &&
        dimensions.customer.columns.customerKey
      ) {
        tableName += "_CustomerKey";
      } else if (dimensions.customer.columns.customerType) {
        tableName += "_CustomerType";
      }
    }
    if (dimensions.location.show) {
      count++;
      if (dimensions.location.columns.city) {
        tableName += "_City";
      } else if (dimensions.location.columns.state) {
        tableName += "_State";
      }
    }

    return `Inventory_${count}D${tableName}`;
  };

  return (
    <Container maxWidth="xl">
      <Box mt={4}>
        <Typography variant="h4" gutterBottom>
          Sales Analytics
        </Typography>

        <Box
          sx={{
            display: "flex",
            gap: 4,
            mt: 3,
            alignItems: "flex-start",
          }}
        >
          {/* Panel bên trái để chọn chiều */}
          <Paper
            elevation={3}
            sx={{ width: "230px", p: 2, minWidth: "150px", flexShrink: 0 }}
          >
            <DimensionsSelector
              dimensions={dimensions}
              setDimensions={(newDimensions) => {
                setDimensions(newDimensions);
                localStorage.setItem(
                  "dimensions",
                  JSON.stringify(newDimensions)
                );
              }}
            />
          </Paper>

          {/* Bảng dữ liệu bên phải */}
          <Box sx={{ flexGrow: 1 }}>
            <DataTable dimensions={dimensions} dataSource={data} />
          </Box>
        </Box>
      </Box>
    </Container>
  );
};

export default SalesAnalytics;
