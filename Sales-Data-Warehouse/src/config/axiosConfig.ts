import axios from "axios";

// Tạo instance Axios với config mặc định
const axiosInstance = axios.create({
  baseURL: "http://localhost:8000", // Thay URL API backend của bạn
  timeout: 10000, // Timeout 10s
  headers: {
    "Content-Type": "application/json",
    // Có thể thêm các header mặc định khác
  },
});

// Interceptor để xử lý request (vd: thêm token)
axiosInstance.interceptors.request.use(
  (config) => {
    // Lấy token từ localStorage hoặc context/state
    const token = localStorage.getItem("access_token");
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Interceptor để xử lý response chung (vd: xử lý lỗi)
axiosInstance.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response) {
      // Ví dụ xử lý lỗi 401 - Unauthorized
      if (error.response.status === 401) {
        // Có thể redirect về trang login hoặc refresh token
        console.error("Unauthorized - Redirect to login");
      }
      // Xử lý các lỗi khác nếu cần
    }
    return Promise.reject(error);
  }
);

export default axiosInstance;
