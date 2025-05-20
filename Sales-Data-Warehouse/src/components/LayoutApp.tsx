import React from "react";
import { Tabs, Tab, Box } from "@mui/material";
import { useLocation, useNavigate, Outlet } from "react-router-dom";

interface RouteTab {
  label: React.ReactNode;
  path: string;
}

interface LayoutAppProps {
  routes: RouteTab[];
}

const LayoutApp: React.FC<LayoutAppProps> = ({ routes }) => {
  const location = useLocation();
  const navigate = useNavigate();

  const currentTabIndex = routes.findIndex((r) =>
    location.pathname.startsWith(r.path)
  );

  const handleChange = (event: React.SyntheticEvent, newValue: number) => {
    navigate(routes[newValue].path);
  };

  return (
    <Box
      sx={{
        display: "flex", // container ngang
        height: "100vh",
      }}
    >
      <Tabs
        orientation="vertical"
        value={currentTabIndex === -1 ? 0 : currentTabIndex}
        onChange={handleChange}
        aria-label="Vertical tabs navigation"
        sx={{
          borderRight: 1,
          borderColor: "divider",
          width: 160,
          alignItems: "flex-start", // căn dọc trái trong Tabs container
        }}
      >
        {routes.map((route, index) => (
          <Tab
            key={index}
            label={
              <Box
                sx={{
                  width: "150px", // cố định độ rộng để tab đều nhau
                  textAlign: "left",
                  fontSize: 14,
                  fontWeight: currentTabIndex === index ? 700 : 500,
                  color:
                    currentTabIndex === index
                      ? "text.primary"
                      : "text.secondary",
                  whiteSpace: "nowrap",
                  overflow: "hidden",
                  textOverflow: "ellipsis",
                }}
              >
                {route.label}
              </Box>
            }
            sx={{
              alignItems: "flex-start", // căn label trong Tab sang trái
              justifyContent: "flex-start",
              paddingLeft: 1,
            }}
          />
        ))}
      </Tabs>

      <Box sx={{ flexGrow: 1, p: 2, overflow: "auto" }}>
        <Outlet />
      </Box>
    </Box>
  );
};

export default LayoutApp;
