import React, { useState, useEffect } from "react";
import DimensionsSelector from "../components/DimensionSelector";
import { Container, Typography, Box } from "@mui/material";
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

const InventoryAnalytics: React.FC = () => {
  const [dimensions, setDimensions] = useState(dimensionsInitialState);

  // Optional: lưu dimensions vào localStorage
  useEffect(() => {
    console.log("okokok");
    const fetchData = async () => {
      localStorage.setItem("dimensions", JSON.stringify(dimensions));
      const res = await getSalesData("Fact_Sales");
      console.log(res);
    };
    fetchData();
  }, []);

  useEffect(() => {
    const fetchData = async () => {
      localStorage.setItem("dimensions", JSON.stringify(dimensions));
      const res = await getSalesData("Fact_Sales");
      console.log(res);
    };
    fetchData();
  }, [dimensions]);

  return (
    <Container>
      <Box mt={4}>
        <Typography variant="h4" gutterBottom>
          Sales Analytics
        </Typography>
        <DimensionsSelector
          dimensions={dimensions}
          setDimensions={setDimensions}
        />
      </Box>
    </Container>
  );
};

export default InventoryAnalytics;
