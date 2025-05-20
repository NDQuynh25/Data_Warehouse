import React, { useState, useMemo } from "react";
import {
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  Typography,
  IconButton,
  Popover,
  Select,
  MenuItem,
  Box,
  TablePagination,
  TableSortLabel,
} from "@mui/material";
import FilterListIcon from "@mui/icons-material/FilterList";

interface DataTableProps {
  dataSource: any[]; // mảng dữ liệu truyền vào từ API
}

type Order = "asc" | "desc";

const DataTable: React.FC<DataTableProps> = ({ dataSource }) => {
  const allColumns = useMemo(() => {
    if (!Array.isArray(dataSource) || dataSource.length === 0) return [];
    return Object.keys(dataSource[0]); // lấy tên các cột từ phần tử đầu tiên
  }, [dataSource]);

  const columnsToDisplay = useMemo(() => {
    return [...allColumns];
  }, [allColumns]);

  const [filters, setFilters] = useState<{ [key: string]: string }>({});
  const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null);
  const [activeCol, setActiveCol] = useState<string | null>(null);
  const [page, setPage] = useState(0);
  const rowsPerPageOptions = [5, 10, 20];
  const [rowsPerPage, setRowsPerPage] = useState(rowsPerPageOptions[0]);
  const [order, setOrder] = useState<Order>("asc");
  const [orderBy, setOrderBy] = useState<string>(columnsToDisplay[0] || "");

  const mockData = useMemo(() => {
    if (!Array.isArray(dataSource)) return [];

    const baseData = dataSource.map((row) => {
      const newRow: any = {};
      allColumns.forEach((col) => (newRow[col] = row[col]));
      return newRow;
    });

    return baseData.map((row) => ({
      ...row,
      quantitySold: (Math.floor(Math.random() * 1000) + 1).toString(),
      revenue:
        (Math.floor(Math.random() * 1000000) + 1000).toLocaleString("vi-VN") +
        " đ",
    }));
  }, [allColumns, dataSource]);

  const columnOptions: { [key: string]: string[] } = useMemo(() => {
    const options: { [key: string]: Set<string> } = {};
    allColumns.forEach((col) => (options[col] = new Set()));
    for (const row of mockData) {
      allColumns.forEach((col) => options[col].add(row[col]));
    }
    return Object.fromEntries(
      Object.entries(options).map(([col, set]) => [col, Array.from(set)])
    );
  }, [mockData, allColumns]);

  const filteredData = useMemo(() => {
    return mockData.filter((row) =>
      allColumns.every((col) => !filters[col] || row[col] === filters[col])
    );
  }, [mockData, filters, allColumns]);

  const comparator = (a: any, b: any, orderBy: string, order: Order) => {
    const valA = a[orderBy];
    const valB = b[orderBy];

    if (valA < valB) return order === "asc" ? -1 : 1;
    if (valA > valB) return order === "asc" ? 1 : -1;
    return 0;
  };

  const sortedData = useMemo(() => {
    return [...filteredData].sort((a, b) => comparator(a, b, orderBy, order));
  }, [filteredData, orderBy, order]);

  const pagedData = useMemo(() => {
    const start = page * rowsPerPage;
    return sortedData.slice(start, start + rowsPerPage);
  }, [sortedData, page, rowsPerPage]);

  const handleChangePage = (
    event: React.MouseEvent<HTMLButtonElement> | null,
    newPage: number
  ) => {
    setPage(newPage);
  };

  const handleChangeRowsPerPage = (
    event: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
  ) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };

  const handleRequestSort = (property: string) => {
    const isAsc = orderBy === property && order === "asc";
    setOrder(isAsc ? "desc" : "asc");
    setOrderBy(property);
  };

  const handleOpenFilter = (
    event: React.MouseEvent<HTMLElement>,
    col: string
  ) => {
    setAnchorEl(event.currentTarget);
    setActiveCol(col);
  };

  const handleCloseFilter = () => {
    setAnchorEl(null);
    setActiveCol(null);
  };

  const open = Boolean(anchorEl);

  if (columnsToDisplay.length === 0) {
    return (
      <Typography variant="body1" color="text.secondary" sx={{ mt: 2 }}>
        Không có dữ liệu để hiển thị.
      </Typography>
    );
  }

  return (
    <Paper sx={{ mt: 2 }}>
      <TableContainer>
        <Table size="small">
          <TableHead>
            <TableRow>
              {columnsToDisplay.map((col) => (
                <TableCell
                  key={col}
                  sortDirection={orderBy === col ? order : false}
                >
                  <Box
                    display="flex"
                    alignItems="center"
                    justifyContent="space-between"
                  >
                    <TableSortLabel
                      active={orderBy === col}
                      direction={orderBy === col ? order : "asc"}
                      onClick={() => handleRequestSort(col)}
                    >
                      {(() => {
                        switch (col) {
                          case "quantitySold":
                            return "Số lượng bán";
                          case "revenue":
                            return "Doanh thu";
                          default:
                            return col.charAt(0).toUpperCase() + col.slice(1);
                        }
                      })()}
                    </TableSortLabel>

                    {allColumns.includes(col) && (
                      <IconButton
                        size="small"
                        onClick={(e) => handleOpenFilter(e, col)}
                      >
                        <FilterListIcon fontSize="small" />
                      </IconButton>
                    )}
                  </Box>
                </TableCell>
              ))}
            </TableRow>
          </TableHead>

          <TableBody>
            {pagedData.map((row, idx) => (
              <TableRow key={idx}>
                {columnsToDisplay.map((col) => (
                  <TableCell key={col}>{row[col]}</TableCell>
                ))}
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>

      <TablePagination
        rowsPerPageOptions={rowsPerPageOptions}
        component="div"
        count={sortedData.length}
        rowsPerPage={rowsPerPage}
        page={page}
        onPageChange={handleChangePage}
        onRowsPerPageChange={handleChangeRowsPerPage}
        labelRowsPerPage="Số dòng mỗi trang"
      />

      <Popover
        open={open}
        anchorEl={anchorEl}
        onClose={handleCloseFilter}
        anchorOrigin={{
          vertical: "bottom",
          horizontal: "left",
        }}
      >
        {activeCol && (
          <Box sx={{ p: 2, minWidth: 150 }}>
            <Typography variant="body2" gutterBottom>
              Lọc {activeCol.charAt(0).toUpperCase() + activeCol.slice(1)}
            </Typography>
            <Select
              value={filters[activeCol] || ""}
              onChange={(e) =>
                setFilters((prev) => ({
                  ...prev,
                  [activeCol]: e.target.value,
                }))
              }
              displayEmpty
              fullWidth
              size="small"
            >
              <MenuItem value="">Tất cả</MenuItem>
              {columnOptions[activeCol]?.map((val) => (
                <MenuItem key={val} value={val}>
                  {val}
                </MenuItem>
              ))}
            </Select>
          </Box>
        )}
      </Popover>
    </Paper>
  );
};

export default DataTable;
