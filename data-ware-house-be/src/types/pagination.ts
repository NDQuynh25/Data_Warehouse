// types/pagination.ts

export interface PaginatedResponse<T> {
  page: number;            // Trang hiện tại
  pageSize: number;        // Số bản ghi trên mỗi trang
  totalRecords?: number;   // Tổng số bản ghi (tuỳ chọn)
  totalPages?: number;     // Tổng số trang (tuỳ chọn)
  data: T[];               // Mảng dữ liệu bản ghi trang hiện tại
}
