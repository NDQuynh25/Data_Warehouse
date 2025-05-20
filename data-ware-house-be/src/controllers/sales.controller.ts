// controllers/sales.controller.ts
import { Request, Response } from "express";
import { fetchDataByTable} from "../services/sales.service";
import { PaginatedResponse } from "../types/pagination";

export const getFactSales = async (req: Request, res: Response): Promise<void> => {
  const table = req.query.table as string;
  const page = parseInt(req.query.page as string) || 1;
  const pageSize = parseInt(req.query.pageSize as string) || 20;

  if (!table) {
    res.status(400).send("Missing table parameter");
    return;
  }

  try {
    const { data, totalRecords } = await fetchDataByTable(table, page, pageSize);

    if (data.length === 0) {
      res.status(404).send("No data found");
      return;
    }

    const totalPages = Math.ceil(totalRecords / pageSize);

    const response: PaginatedResponse<any> = {
      page,
      pageSize,
      totalRecords,
      totalPages,
      data,
    };

    res.status(200).json(response);
  } catch (error) {
    console.error("Error fetching data:", error);
    res.status(500).send("Server error");
  }
};
