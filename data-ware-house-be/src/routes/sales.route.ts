import { Router } from "express";
import { getFactSales } from "../controllers/sales.controller";

const router = Router();

router.get("", getFactSales);


export default router;
