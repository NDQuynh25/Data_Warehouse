import React from "react";
import {
  BrowserRouter as Router,
  Routes,
  Route,
  Navigate,
} from "react-router-dom";
import LayoutApp from "./components/LayoutApp";
import SalesAnalytics from "./pages/SalesAnalytics";
import Page2 from "./pages/InventoryAnalytics";

const App: React.FC = () => {
  return (
    <Router>
      <Routes>
        {/* Redirect từ '/' sang /analysis/sales */}
        <Route path="/" element={<Navigate to="/analysis/sales" replace />} />

        {/* LayoutApp làm layout chung cho tất cả /analysis/... */}
        <Route path="/analysis" element={<LayoutApp routes={routes} />}>
          <Route path="sales" element={<SalesAnalytics />} />
          <Route path="inventory" element={<Page2 />} />
          {/* Bạn có thể thêm route con ở đây */}
        </Route>

        {/* Nếu bạn muốn bắt 404 */}
        <Route path="*" element={<div>Page not found</div>} />
      </Routes>
    </Router>
  );
};

const routes = [
  { label: "Sales Analytics", path: "/analysis/sales" },
  { label: "Inventory", path: "/analysis/inventory" },
];

export default App;
