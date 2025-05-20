import axiosInstance from "../config/axiosConfig";

export const getSalesData = async (table: string) => {
  try {
    const response = await axiosInstance.get(`/sales`, {
      params: {
        table: table,
      },        

    })
    return response.data;
  } catch (error) {
    throw error;
  }
};